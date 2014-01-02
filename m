Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751172AbaABLIn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 06:08:43 -0500
Received: from hqemgate16.nvidia.com ([216.228.121.65]:7651 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750744AbaABLIl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 06:08:41 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 02 Jan 2014 03:09:35 -0800
Message-ID: <52C548B6.60902@nvidia.com>
Date: Thu, 2 Jan 2014 19:08:38 +0800
From: bilhuang <bilhuang@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Rob Herring <robherring2@gmail.com>,
        Grant Likely <grant.likely@linaro.org>
CC: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Thierry Reding <thierry.reding@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH v5 1/1] cpufreq: tegra: Re-model Tegra20 cpufreq driver
References: <1387451926-21373-1-git-send-email-bilhuang@nvidia.com>	<CAKohpomCPJYd+d_NnM9gxwQ7bH6C6=iLxbiWZbfNcjZ8Bi+2wA@mail.gmail.com>	<52B41B18.30302@nvidia.com>	<CAKohpontQwTc4KP7XMvtkvS2sQTyF+ngXnXfbJ1ev+MLEp-H0g@mail.gmail.com>	<52B41F1B.3030005@nvidia.com>	<52B4707F.4040303@wwwdotorg.org> <CAKohpokwO3BgXr9Le02bNo=771saWuDe2H=fgQzcboRWxwVzOg@mail.gmail.com>
In-Reply-To: <CAKohpokwO3BgXr9Le02bNo=771saWuDe2H=fgQzcboRWxwVzOg@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/23/2013 01:06 PM, Viresh Kumar wrote:
> Ccc'ing Grant and Rob as well.
>
> On 20 December 2013 21:59, Stephen Warren <swarren@wwwdotorg.org> wrote:
>> No, I definitely don't agree here. The rules for arch/arm64 are: no
>> platform-specific code. We should immediately start planning for that.
>> If this means renaming the file that creates the virtual device from
>> tegra-cpufreq.c to something else, so be it, but we shouldn't go
>> backwards and push stuff into the arch directories.
>
> I don't mind doing this now as well if it is generic enough. I wasn't sure
> if you guys wanted to take it on now..
>
> @Bill: So, please create a separate commit for creating such file which
> would create a virtual device for probing cpufreq drivers with name picked
> from root-node. Compilation of such a file should be configurable but if
> it is compiled, then it shouldn't cause any problems if that device isn't
> used, for multiplatform kernels specially..
>
> Probably then you can widen the scope of your patchset by modifying
> some of the existing drivers which require a device to get cpufreq
> driver probed. Currently they are all making such a device from
> their arch/ stuff.
Actually, I don't have plan or resource on doing this, would it be 
better that you help to do that instead? Thanks.
>
> I am not sure about the location of such file. Should this be placed in DT
> code somewhere or kept in cpufreq? Rob/Grant ??
>
Do we have consensus on where to create such file?
> --
> viresh
>

