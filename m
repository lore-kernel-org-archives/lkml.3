Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751744Ab3LSHOh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 02:14:37 -0500
Received: from hqemgate14.nvidia.com ([216.228.121.143]:18906 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751075Ab3LSHOg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 02:14:36 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 18 Dec 2013 23:16:41 -0800
Message-ID: <52B29CD0.1000801@nvidia.com>
Date: Thu, 19 Dec 2013 12:44:24 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>,
        "thierry.reding@gmail.com" <thierry.reding@gmail.com>
CC: "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] ARM: tegra: fix missing pincontrol configuration
 for Venice2
References: <1387371179-16725-1-git-send-email-ldewangan@nvidia.com> <52B20C0D.9030200@wwwdotorg.org>
In-Reply-To: <52B20C0D.9030200@wwwdotorg.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 19 December 2013 02:26 AM, Stephen Warren wrote:
> On 12/18/2013 05:52 AM, Laxman Dewangan wrote:
>> Compare the initial population of default pinmux configuration of Venice2
>> with the chrome branch and add/fix the missing configurations.
> Wow, that's a big chunk of changes. Are you sure this is correct? Why
> was the original patch (which added the pinctrl nodes) so incorrect?

The pinmux which got added is based on the venice2 pinmux spreadsheet 
where I covered only the SFIO pin groups.

https://wiki.nvidia.com/engwiki/index.php/Platform_Design_Center/Projects_Archive/PM371#pinmux


After comparing with the chrome, I also added the pinmux for all pins 
which are used as GPIO and hence the change is big.
This is complete pinmux based on chrome kernel-next.
I booted chrome with this pinmux and not observe any behavioral change.

> Thierry, I thought you had mentioned comparing the pinctrl setup in
> linux-next with the downstream kernel for Venice2 and only found a
> difference in the PWM settings, which you sent a patch for. However,
> this patch is much larger than that. Where's the disconnect?

