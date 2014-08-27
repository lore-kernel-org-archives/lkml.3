Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756696AbaH0C0T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 22:26:19 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:10115 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751444AbaH0C0R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 22:26:17 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 26 Aug 2014 19:16:13 -0700
Message-ID: <53FD41B4.8040402@nvidia.com>
Date: Wed, 27 Aug 2014 10:25:56 +0800
From: Wei Ni <wni@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>,
        Eduardo Valentin <edubezval@gmail.com>
CC: Mikko Perttunen <mperttunen@nvidia.com>, <khali@linux-fr.org>,
        <linux@roeck-us.net>, <lm-sensors@lm-sensors.org>,
        <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 1/4] hwmon: (lm90) split set&show temp as common codes
References: <1408948188-4181-1-git-send-email-wni@nvidia.com> <1408948188-4181-2-git-send-email-wni@nvidia.com> <53FB2AAA.30601@nvidia.com> <53FBF09F.8050502@nvidia.com> <20140826121729.GC15219@developer> <53FCB7C6.8000503@wwwdotorg.org>
In-Reply-To: <53FCB7C6.8000503@wwwdotorg.org>
X-Originating-IP: [10.19.224.131]
X-ClientProxiedBy: HKMAIL101.nvidia.com (10.18.16.10) To
 HKMAIL101.nvidia.com (10.18.16.10)
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/27/2014 12:37 AM, Stephen Warren wrote:
> On 08/26/2014 06:17 AM, Eduardo Valentin wrote:
>> On Tue, Aug 26, 2014 at 10:27:43AM +0800, Wei Ni wrote:
>>> On 08/25/2014 08:23 PM, Mikko Perttunen wrote:
>>>> FWIW, please fix the authorship information for next version.
>>>
>>> Sorry, I didn't get your point, did you mean I should remove the line
>>> "From: lightning314 <wni@nvidia.com>" ? Yes I made a mistake on it, I
>>> will remove it in next version.
>>
>> No Wei, don't remove the author line. Well, based on email, it is your
>> patch, so, removing may satisfy.
> 
> The patch authorship should be fixed to have the correct value;
> "lightning314" is not a valid real name. In turn, depending on your git
> email configuration, this might automatically remove that line from the
> message, since it might then exactly match the email's from address.

Got it, thanks for the comments.
I get this patch from the patchwork, so it use my username
"lightning314". Anyway, I will fix it in next version.

Wei.

