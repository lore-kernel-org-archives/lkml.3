Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755417AbaHEPI6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 11:08:58 -0400
Received: from mail-ob0-f178.google.com ([209.85.214.178]:65223 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755211AbaHEPIt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 11:08:49 -0400
MIME-Version: 1.0
In-Reply-To: <53D2255C.9050006@linaro.org>
References: <1406020499-5537-1-git-send-email-takahiro.akashi@linaro.org>
	<1406020499-5537-4-git-send-email-takahiro.akashi@linaro.org>
	<53D082E9.8090303@amacapital.net>
	<53D09C4F.9010104@linaro.org>
	<CALCETrWTDS7VSyuR5wgGxpu-_YMWVUVmv9ht6t1tCSX=GA46cQ@mail.gmail.com>
	<53D2255C.9050006@linaro.org>
Date: Tue, 5 Aug 2014 08:08:47 -0700
X-Google-Sender-Auth: shAHPrFiLsLY06yLuiZDHCuSEOE
Message-ID: <CAGXu5jJL=zXuSRNomGrB09kqpUhEpkuxDH18JN4NRbWocMw4xg@mail.gmail.com>
Subject: Re: [PATCH v5 3/3] arm64: Add seccomp support
From: Kees Cook <keescook@chromium.org>
To: AKASHI Takahiro <takahiro.akashi@linaro.org>
Cc: Andy Lutomirski <luto@amacapital.net>, Deepak Saxena <dsaxena@linaro.org>,
        Will Drewry <wad@chromium.org>, linaro-kernel@lists.linaro.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Will Deacon <will.deacon@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Lee Campbell <leecam@google.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 25, 2014 at 2:37 AM, AKASHI Takahiro
<takahiro.akashi@linaro.org> wrote:
> I found a bug in my current patch (v5). When 32-bit tracer skips a system call,
> we should not update syscallno from x8 since syscallno is re-written directly
> via ptrace(PTRACE_SET_SYSCALL).

Ah, yes. Will aarch64 have a PTRACE_SET_SYSCALL option, or is this
strictly a 32-bit vs 64-bit issue?

> I'm sure that my next version should work with 32/64-bit tracers on 64-bit
> kernel.

Do you have a git tree uploaded anywhere? I'd love to follow this more
closely. When do you expect a v6?

Thanks!

-Kees

-- 
Kees Cook
Chrome OS Security
