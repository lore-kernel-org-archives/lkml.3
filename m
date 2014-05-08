Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755698AbaEHUOJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 16:14:09 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:55763 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755616AbaEHUOE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 16:14:04 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: dirk.brandewie@gmail.com
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        Dirk Brandewie <dirk.j.brandewie@intel.com>
Subject: Re: [PATCH 0/5] updates for intel_pstate
Date: Thu, 08 May 2014 22:30:44 +0200
Message-ID: <3320314.vMXib5RYFF@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.14.0-rc7+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1399579047-5792-1-git-send-email-dirk.j.brandewie@intel.com>
References: <1399579047-5792-1-git-send-email-dirk.j.brandewie@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, May 08, 2014 12:57:22 PM dirk.brandewie@gmail.com wrote:
> From: Dirk Brandewie <dirk.j.brandewie@intel.com>
> 
> Patches 1-4 are bugfixes.  Patch 4 specifically removes the wreckage
> caused by C0 tracking change. 

I would appreciate sending such stuff before the -rc4 time frame.

> Patch 5 Adds new CPU IDs for the Broadwell processors.
> 
> Dirk Brandewie (5):
>   intel_pstate: Set turbo VID for Baytrail
>   intel_pstate: remove setting P state to MAX on init
>   intel_pstate: Fix fixed point rounding macro
>   intel_pstate: Remove C0 tracking
>   intel_pstate: Add CPU IDs for Broadwell processors
> 
>  drivers/cpufreq/intel_pstate.c | 52 +++++++++++++++++-------------------------
>  1 file changed, 21 insertions(+), 31 deletions(-)

I'll queue them up for 3.15-rc6, but that's a bit too late.

Next time I may just wait for the next merge window, fixes or not.


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
