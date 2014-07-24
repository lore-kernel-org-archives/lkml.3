Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759454AbaGXPQu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 11:16:50 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:17685 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759423AbaGXPQs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 11:16:48 -0400
Date: Thu, 24 Jul 2014 16:16:28 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: AKASHI Takahiro <takahiro.akashi@linaro.org>,
        Deepak Saxena <dsaxena@linaro.org>, Will Drewry <wad@chromium.org>,
        Kees Cook <keescook@chromium.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Will Deacon <Will.Deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v5 3/3] arm64: Add seccomp support
Message-ID: <20140724151628.GH13371@arm.com>
References: <1406020499-5537-1-git-send-email-takahiro.akashi@linaro.org>
 <1406020499-5537-4-git-send-email-takahiro.akashi@linaro.org>
 <53D082E9.8090303@amacapital.net>
 <53D09C4F.9010104@linaro.org>
 <CALCETrWTDS7VSyuR5wgGxpu-_YMWVUVmv9ht6t1tCSX=GA46cQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrWTDS7VSyuR5wgGxpu-_YMWVUVmv9ht6t1tCSX=GA46cQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 24, 2014 at 04:00:03PM +0100, Andy Lutomirski wrote:
> On Jul 23, 2014 10:40 PM, "AKASHI Takahiro" <takahiro.akashi@linaro.org> wrote:
> > when I implemented audit for arm64, the assumptions were
> > * If userspace is LE, then the kernel is also LE and if BE, then the kernel is BE.
> > * the syscall numbers and how arguments are encoded are the same btw BE and LE.
> > So syscall_get_arch() always return the same value.
> 
> If arm64 ever adds support for mixed-endian userspace, this could
> become awkward.  Hmm.

I really doubt we would ever support mixed endian user space. Too many
problems with translating syscalls, futexes (someone looked into this
and gave up eventually).

-- 
Catalin
