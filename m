Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422995AbaKNXdR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 18:33:17 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:51253 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1422885AbaKNXdP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 18:33:15 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: dirk.brandewie@gmail.com
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        dirk.brandweie@gmail.com, robert.a.kasten@intel.com,
        charles.d.prestopine@intel.com, x86@kernel.org,
        Dirk Brandewie <dirk.j.brandewie@intel.com>
Subject: Re: [PATCH 0/2] intel_pstate: Add support for hardware managed P states (HWP)
Date: Sat, 15 Nov 2014 00:54:14 +0100
Message-ID: <1503544.Me07i8iiBH@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1415295647-4063-1-git-send-email-dirk.j.brandewie@intel.com>
References: <1415295647-4063-1-git-send-email-dirk.j.brandewie@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, November 06, 2014 09:40:45 AM dirk.brandewie@gmail.com wrote:
> From: Dirk Brandewie <dirk.j.brandewie@intel.com>
> 
> This patch set adds support for HWP. When HWP is enabled the CPU will
> do P state autonomously and intel_pstate simply provides an interface
> to forward user preferences to the CPU while maintaining the
> interfaces required by the cpufreq core. 
> 
> Dirk Brandewie (2):
>   x86: Add support for Intel HWP feature detection.
>   intel_pstate: Add support for HWP
> 
>  Documentation/cpu-freq/intel-pstate.txt |  37 ++++++++----
>  Documentation/kernel-parameters.txt     |   3 +
>  arch/x86/include/asm/cpufeature.h       |   5 ++
>  arch/x86/include/uapi/asm/msr-index.h   |  41 +++++++++++++
>  arch/x86/kernel/cpu/scattered.c         |   5 ++
>  drivers/cpufreq/intel_pstate.c          | 102 +++++++++++++++++++++++++++++++-
>  6 files changed, 178 insertions(+), 15 deletions(-)

Both patches queued up for 3.19 (with assorted fixups), thanks!

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
