Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752155AbaKBQhW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2014 11:37:22 -0500
Received: from mail-wi0-f180.google.com ([209.85.212.180]:64215 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751906AbaKBQhL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2014 11:37:11 -0500
Message-ID: <54565DB2.4040700@gmail.com>
Date: Sun, 02 Nov 2014 17:37:06 +0100
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Kees Cook <keescook@chromium.org>, Andy Lutomirski <luto@amacapital.net>
CC: mtk.manpages@gmail.com, Linux API <linux-api@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] seccomp.2: document seccomp syscall
References: <1411685267-27949-1-git-send-email-keescook@chromium.org>	<1411685267-27949-2-git-send-email-keescook@chromium.org>	<CALCETrVaYjrq0xBDouu9ZQ3Hm65Dmt2Uih4zscCGcDC+M89+qg@mail.gmail.com> <CAGXu5jJEn5QZPrVa4UjuT34PVuadhXqSb_d=o3W04QvZq-fMNw@mail.gmail.com>
In-Reply-To: <CAGXu5jJEn5QZPrVa4UjuT34PVuadhXqSb_d=o3W04QvZq-fMNw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/26/2014 07:55 AM, Kees Cook wrote:
> On Thu, Sep 25, 2014 at 6:29 PM, Andy Lutomirski <luto@amacapital.net> wrote:
>> On Thu, Sep 25, 2014 at 3:47 PM, Kees Cook <keescook@chromium.org> wrote:
>>> +.SH VERSIONS
>>> +This system call first appeared in Linux 3.16.
>>> +.\" FIXME Add glibc version
>>
>> 3.17?  (And remove FIXME?)
>>
>> Otherwise I like it.
> 
> Ooops, yes: 3.17. Michael do you want me to resend with that
> corrected, or do you want to handle fixing that from this version?

No need. I've fixed that.

Cheers,

Michael


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
