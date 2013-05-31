Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752622Ab3EaGK2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 02:10:28 -0400
Received: from mail-ie0-f181.google.com ([209.85.223.181]:37759 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752114Ab3EaGKY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 02:10:24 -0400
MIME-Version: 1.0
In-Reply-To: <tip-757885e94a22bcc82beb9b1445c95218cb20ceab@git.kernel.org>
References: <1369940959-2077-5-git-send-email-jacob.shin@amd.com>
	<tip-757885e94a22bcc82beb9b1445c95218cb20ceab@git.kernel.org>
Date: Thu, 30 May 2013 23:10:23 -0700
X-Google-Sender-Auth: _w-ohNIvhzFr9IoTA12xJ0doREc
Message-ID: <CAE9FiQWJbM=4WOzTfrAbNLgatkH_TXavK8vp1ZXHjw=bs-Obvg@mail.gmail.com>
Subject: Re: [tip:x86/microcode] x86, microcode, amd: Early microcode patch
 loading support for AMD
From: Yinghai Lu <yinghai@kernel.org>
To: Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Yu, Fenghua" <fenghua.yu@intel.com>, Jacob Shin <jacob.shin@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Cc: "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 30, 2013 at 8:31 PM, tip-bot for Jacob Shin
<tipbot@zytor.com> wrote:
> Commit-ID:  757885e94a22bcc82beb9b1445c95218cb20ceab
> Gitweb:     http://git.kernel.org/tip/757885e94a22bcc82beb9b1445c95218cb20ceab
> Author:     Jacob Shin <jacob.shin@amd.com>
> AuthorDate: Thu, 30 May 2013 14:09:19 -0500
> Committer:  H. Peter Anvin <hpa@linux.intel.com>
> CommitDate: Thu, 30 May 2013 20:19:25 -0700
>
> x86, microcode, amd: Early microcode patch loading support for AMD
>
> Add early microcode patch loading support for AMD.
>
> Signed-off-by: Jacob Shin <jacob.shin@amd.com>
> Link: http://lkml.kernel.org/r/1369940959-2077-5-git-send-email-jacob.shin@amd.com
> Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
> Cc: Fenghua Yu <fenghua.yu@intel.com>
> ---
>  Documentation/x86/early-microcode.txt  |  11 +-
>  arch/x86/Kconfig                       |  14 ++-
>  arch/x86/include/asm/microcode_amd.h   |  14 +++
>  arch/x86/kernel/Makefile               |   1 +
>  arch/x86/kernel/microcode_amd.c        |  22 ++++
>  arch/x86/kernel/microcode_amd_early.c  | 222 +++++++++++++++++++++++++++++++++
>  arch/x86/kernel/microcode_core_early.c |  43 ++++++-
>  7 files changed, 310 insertions(+), 17 deletions(-)
>

WARNING: arch/x86/kernel/built-in.o(.cpuinit.text+0x7115): Section
mismatch in reference from the function load_ucode_amd_ap() to the
function .init.text:find_ucode_in_initrd()
The function __cpuinit load_ucode_amd_ap() references
a function __init find_ucode_in_initrd().
If find_ucode_in_initrd is only used by load_ucode_amd_ap then
annotate find_ucode_in_initrd with a matching annotation.
