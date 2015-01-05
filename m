Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753093AbbAEG4V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 01:56:21 -0500
Received: from hqemgate16.nvidia.com ([216.228.121.65]:7118 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751124AbbAEG4U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 01:56:20 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Sun, 04 Jan 2015 22:49:21 -0800
Message-ID: <54AA356A.8080309@nvidia.com>
Date: Mon, 5 Jan 2015 14:55:38 +0800
From: Vince Hsu <vinceh@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Lucas Stach <dev@lynxeye.de>
CC: <thierry.reding@gmail.com>, <swarren@wwwdotorg.org>, <gnurou@gmail.com>,
        <bskeggs@redhat.com>, <martin.peres@free.fr>,
        <seven@nimrod-online.com>, <samuel.pitoiset@gmail.com>,
        <nouveau@lists.freedesktop.org>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/11] ARM: tegra: add function to control the GPU rail
 clamp
References: <1419331204-26679-1-git-send-email-vinceh@nvidia.com>			 <1419331204-26679-2-git-send-email-vinceh@nvidia.com>		 <1419426990.2179.7.camel@lynxeye.de> <549B7638.2010405@nvidia.com>	 <1419539683.2165.6.camel@lynxeye.de> <54A0C148.6030400@nvidia.com> <1419957752.4082.2.camel@lynxeye.de>
In-Reply-To: <1419957752.4082.2.camel@lynxeye.de>
X-Originating-IP: [10.19.108.126]
X-ClientProxiedBy: HKMAIL101.nvidia.com (10.18.16.10) To
 HKMAIL101.nvidia.com (10.18.16.10)
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 12/31/2014 12:42 AM, Lucas Stach wrote:
> Am Montag, den 29.12.2014, 10:49 +0800 schrieb Vince Hsu:
>
> [...]
>
>>>> That's a read fence to assure the post of the previous writes through
>>>> Tegra interconnect. (copy-paster from
>>>> https://android.googlesource.com/kernel/tegra.git/+/28b107dcb3aa122de8e94e48af548140d519298f)
>>> I see what it does, the question is more about why this is needed.
>>> What is the Tegra interconnect? According to the TRM the Tegra contains
>>> some standard AXI <-> AHB <-> APB bridges. That a read is needed to
>>> assure the write is posted to the APB bus seems to imply that there is
>>> some write buffering in one of those bridges. Can we get this documented
>>> somewhere?
>> The TRM does mention a read after the write. Check the section 32.2.2.3.
>>
> Unfortunately this doesn't seem to be included in the public TRM. It
> would be nice if this could be documented either in the next version of
> the TRM or as a public Appnote.
>
It should be in the latest public TRM. Could you check again?

Thanks,
Vince

