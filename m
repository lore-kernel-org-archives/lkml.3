Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753355AbaIZB37 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 21:29:59 -0400
Received: from mail-lb0-f175.google.com ([209.85.217.175]:52528 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753148AbaIZB3u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 21:29:50 -0400
MIME-Version: 1.0
In-Reply-To: <1411685267-27949-2-git-send-email-keescook@chromium.org>
References: <1411685267-27949-1-git-send-email-keescook@chromium.org> <1411685267-27949-2-git-send-email-keescook@chromium.org>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 25 Sep 2014 18:29:29 -0700
Message-ID: <CALCETrVaYjrq0xBDouu9ZQ3Hm65Dmt2Uih4zscCGcDC+M89+qg@mail.gmail.com>
Subject: Re: [PATCH 1/2] seccomp.2: document seccomp syscall
To: Kees Cook <keescook@chromium.org>
Cc: Michael Kerrisk-manpages <mtk.manpages@gmail.com>,
        Linux API <linux-api@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 25, 2014 at 3:47 PM, Kees Cook <keescook@chromium.org> wrote:
> +.SH VERSIONS
> +This system call first appeared in Linux 3.16.
> +.\" FIXME Add glibc version

3.17?  (And remove FIXME?)

Otherwise I like it.

--Andy
