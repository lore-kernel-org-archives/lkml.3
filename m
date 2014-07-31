Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756031AbaGaAL2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 20:11:28 -0400
Received: from mail-vc0-f178.google.com ([209.85.220.178]:52810 "EHLO
	mail-vc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753892AbaGaAL1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 20:11:27 -0400
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:157d:781a:650a:7145:334d]
In-Reply-To: <1406764649-20326-1-git-send-email-behanw@converseincode.com>
References: <1406764649-20326-1-git-send-email-behanw@converseincode.com>
Date: Wed, 30 Jul 2014 17:11:26 -0700
Message-ID: <CAOesGMjcFr72LU8akuooE-BodAa8X8tyT0biczxepKo37rNArQ@mail.gmail.com>
Subject: Re: [PATCH 0/4] LLVMLinux: Patches to enable the kernel to be
 compiled with clang/LLVM
From: Olof Johansson <olof@lixom.net>
To: behanw@converseincode.com
Cc: ard.biesheuvel@linaro.org, Catalin Marinas <catalin.marinas@arm.com>,
        k.khlebnikov@samsung.com, Peter Zijlstra <peterz@infradead.org>,
        takahiro.akashi@linaro.org, Thomas Gleixner <tglx@linutronix.de>,
        Will Deacon <will.deacon@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, David Woodhouse <dwmw2@infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 30, 2014 at 4:57 PM,  <behanw@converseincode.com> wrote:
> From: Behan Webster <behanw@converseincode.com>
>
> This patch set moves from using locally defined named registers to access the
> stack pointer to using a globally defined named register. This allows the code
> to work both with gcc and clang.
>
> The LLVMLinux project aims to fully build the Linux kernel using both gcc and
> clang (the C front end for the LLVM compiler infrastructure project).
>
> Behan Webster (4):
>   arm64: LLVMLinux: Add current_stack_pointer() for arm64
>   arm64: LLVMLinux: Use current_stack_pointer in save_stack_trace_tsk
>   arm64: LLVMLinux: Calculate current_thread_info from
>     current_stack_pointer
>   arm64: LLVMLinux: Use current_stack_pointer in kernel/traps.c

Series:

Reviewed-by: Olof Johansson <olof@lixom.net>
