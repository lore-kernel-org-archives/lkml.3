Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753721AbaIZFzm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 01:55:42 -0400
Received: from mail-qg0-f50.google.com ([209.85.192.50]:34320 "EHLO
	mail-qg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752941AbaIZFzk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 01:55:40 -0400
MIME-Version: 1.0
In-Reply-To: <CALCETrVaYjrq0xBDouu9ZQ3Hm65Dmt2Uih4zscCGcDC+M89+qg@mail.gmail.com>
References: <1411685267-27949-1-git-send-email-keescook@chromium.org>
	<1411685267-27949-2-git-send-email-keescook@chromium.org>
	<CALCETrVaYjrq0xBDouu9ZQ3Hm65Dmt2Uih4zscCGcDC+M89+qg@mail.gmail.com>
Date: Thu, 25 Sep 2014 22:55:39 -0700
X-Google-Sender-Auth: tXQrJKOdkqHZECdQIWZSUt9B0JQ
Message-ID: <CAGXu5jJEn5QZPrVa4UjuT34PVuadhXqSb_d=o3W04QvZq-fMNw@mail.gmail.com>
Subject: Re: [PATCH 1/2] seccomp.2: document seccomp syscall
From: Kees Cook <keescook@chromium.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Michael Kerrisk-manpages <mtk.manpages@gmail.com>,
        Linux API <linux-api@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 25, 2014 at 6:29 PM, Andy Lutomirski <luto@amacapital.net> wrote:
> On Thu, Sep 25, 2014 at 3:47 PM, Kees Cook <keescook@chromium.org> wrote:
>> +.SH VERSIONS
>> +This system call first appeared in Linux 3.16.
>> +.\" FIXME Add glibc version
>
> 3.17?  (And remove FIXME?)
>
> Otherwise I like it.

Ooops, yes: 3.17. Michael do you want me to resend with that
corrected, or do you want to handle fixing that from this version?

Thanks!

-Kees

-- 
Kees Cook
Chrome OS Security
