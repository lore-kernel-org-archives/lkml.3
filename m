Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932153Ab3GPLPx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 07:15:53 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:14686 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753087Ab3GPLPw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 07:15:52 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 16 Jul 2013 04:13:49 -0700
Message-ID: <51E52B28.9090708@nvidia.com>
Date: Tue, 16 Jul 2013 19:14:48 +0800
From: Wei Ni <wni@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: "khali@linux-fr.org" <khali@linux-fr.org>,
        "linux@roeck-us.net" <linux@roeck-us.net>,
        "thierry.reding@gmail.com" <thierry.reding@gmail.com>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH v3 0/2] Enable lm90 in Tegra30 and Tegra114.
References: <1373615364-18559-1-git-send-email-wni@nvidia.com> <51E427F1.9010106@wwwdotorg.org> <51E42DB0.8090006@wwwdotorg.org>
In-Reply-To: <51E42DB0.8090006@wwwdotorg.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/16/2013 01:13 AM, Stephen Warren wrote:
> On 07/15/2013 10:48 AM, Stephen Warren wrote:
>> On 07/12/2013 01:49 AM, Wei Ni wrote:
>>> Enable thermal sensor lm90 for Tegra30 Cardhu and Tegra114 Dalmore.
>>
>> I have applied the series to Tegra's for-3.12/dt branch.
> 
> Actually, I see the following on Dalmore (although Cardhu works):
> 
> [   29.448539] lm90 0-004c: Register 0x4 read failed (-121)
> [   29.453930] lm90 0-004c: Failed to read convrate register!
> [   29.460034] lm90 0-004c: Register 0x3 read failed (-121)
> [   29.465408] lm90 0-004c: Initialization failed!
> 
> So, there's something wrong here, and I've dropped the patch for
> Dalmore. Does this patch actually work for you?
> 
I test it with the Chrome u-boot, the lm90 works fine.
But today, if I tried to use the uboot from
git://git.denx.de/u-boot-tegra.git, I can repo your errors, it seems the
i2c can't work, the lm90 driver read register failed.
I traced it, but can't find the root cause yet.
