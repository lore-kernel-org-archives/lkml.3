Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754610AbaIARBZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 13:01:25 -0400
Received: from mail-qa0-f42.google.com ([209.85.216.42]:53553 "EHLO
	mail-qa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754180AbaIARBX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 13:01:23 -0400
MIME-Version: 1.0
Reply-To: mtk.manpages@gmail.com
In-Reply-To: <14820c115f6.f730a96c253877.2650827516078037638@zoho.com>
References: <53F5315D.6090003@gmail.com> <14820c115f6.f730a96c253877.2650827516078037638@zoho.com>
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Date: Mon, 1 Sep 2014 19:01:02 +0200
Message-ID: <CAKgNAkjccb9kcpc_wCT2nFW_K7b3xJe-S8FNW9ja0937duWejw@mail.gmail.com>
Subject: Re: For review: namespaces(7) man page
To: Vitaly Rybnikov <frodox@zoho.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        "linux-man@vger.kernel.org" <linux-man@vger.kernel.org>,
        richard.weinberger@gmail.com,
        Containers <containers@lists.linux-foundation.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Andy Lutomirski <luto@amacapital.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 29, 2014 at 9:53 AM, Vitaly Rybnikov <frodox@zoho.com> wrote:
> Hello, Michael et al.
>
> You have an errata here:
>
>> /proc/[pid]/ns/uts (since Linux 3.0)
>> This file is a handle for the IPC namespace of the
>> process.
>
> It should be:
> /proc/[pid]/ns/uts (since Linux 3.0)
> This file is a handle for the UTS namespace of the
> process.

Thanks, Vitaly. Fixed.

Cheers,

Michael




-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
