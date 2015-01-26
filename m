Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753271AbbAZAHr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 19:07:47 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:60141 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752027AbbAZAHp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 19:07:45 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Sudeep Holla <Sudeep.Holla@arm.com>,
        lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Linux PM mailing list <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] : cpuidle-big.little fix when mcpm is not available
Date: Mon, 26 Jan 2015 01:30:26 +0100
Message-ID: <10706276.ZxA2zPECXL@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <54C5002C.4050600@linaro.org>
References: <54C5002C.4050600@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, January 25, 2015 03:39:40 PM Daniel Lezcano wrote:
> Hi Rafael,
> 
> This pull request has a single patch which is a fix for the 
> cpuidle-big.little driver. If the mcpm backend is not available because 
> the CCI is not defined in the DT, the cpuidle driver will 
> unconditionally assume it is and call the mcpm functions leading to a 
> kernel WARNING.
> 
> Sudeep Holla fixed that by checking at the init time the mcpm is 
> available before initializing the deeper idle states.
> 
> Thanks
>    -- Daniel
> 
> The following changes since commit ec6f34e5b552fb0a52e6aae1a5afbbb1605cc6cc:
> 
>    Linux 3.19-rc5 (2015-01-18 18:02:20 +1200)
> 
> are available in the git repository at:
> 
>    http://git.linaro.org/people/daniel.lezcano/linux.git cpuidle/3.20
> 
> for you to fetch changes up to 194fe6f28e2819d3f50fbed24c3b72f21501dbfa:
> 
>    drivers: cpuidle: Don't initialize big.LITTLE driver if MCPM is 
> unavailable (2015-01-23 15:05:48 +0100)
> 
> ----------------------------------------------------------------
> Sudeep Holla (1):
>        drivers: cpuidle: Don't initialize big.LITTLE driver if MCPM is 
> unavailable
> 
>   drivers/cpuidle/cpuidle-big_little.c | 4 ++++
>   1 file changed, 4 insertions(+)

Pulled, thanks!


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
