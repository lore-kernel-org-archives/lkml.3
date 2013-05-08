Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753815Ab3EGX6w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 19:58:52 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:37733 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751981Ab3EGX6v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 19:58:51 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: dirk.brandewie@gmail.com
Cc: linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org,
        Linux PM list <linux-pm@vger.kernel.org>
Subject: Re: [PATCH 0/6] Intel pstate driver update
Date: Wed, 08 May 2013 02:07:15 +0200
Message-ID: <4686510.A1KmKYg1tS@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.9.0+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1367940030-19311-1-git-send-email-dirk.j.brandewie@gmail.com>
References: <1367940030-19311-1-git-send-email-dirk.j.brandewie@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, May 07, 2013 08:20:24 AM dirk.brandewie@gmail.com wrote:
> From: dirk <dirk.brandewie@gmail.com>
> 
> Collection of updates for cpufreq/intel_pstate.c
> 
> Patches 1-3 are bugfixes and marked for stable
> 
> Patches 4-6 are code cleanup with no functional changes.
> 
> 
> Dirk Brandewie (6):
>   cpufreq/intel_pstate: remove idle time and duration from sample and
>     calculations
>   cpufreq/intel_pstate: use lowest requested max performance
>   cpufreq/intel_pstate: fix ffmpeg regression
>   cpufreq/intel_pstate: Remove idle mode PID
>   cpufreq/intel_pstate: Remove unused code
>   cpufreq/intel_pstate: remove #ifdef MODULE compile fence
> 
>  drivers/cpufreq/intel_pstate.c | 122 +++++++----------------------------------
>  1 file changed, 20 insertions(+), 102 deletions(-)

All queued up for a post-3.10-rc1 push as 3.10 material, but I have a couple
of comments.

First, the patches didn't apply for me cleanly.  I needed to fix up one of
them manually to make it apply and patch [5/6] didn't appear to be necessary
at all (it made changes that had been made previously).  Please check the
bleeding-edge branch of my tree to see if the code is what you wanted and
let me know (either way).

Second, can you please CC your cpufreq submissions to linux-pm@vger.kernel.org?
That will allow me to use Patchwork for managing them, which is much more
convenient than plain email.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
