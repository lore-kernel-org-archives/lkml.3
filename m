Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757206Ab3CDMuY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 07:50:24 -0500
Received: from mail-da0-f45.google.com ([209.85.210.45]:40493 "EHLO
	mail-da0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755443Ab3CDMuX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 07:50:23 -0500
MIME-Version: 1.0
Reply-To: mtk.manpages@gmail.com
In-Reply-To: <1362369010.29250.3@driftwood>
References: <CAKgNAki=mUYuu_Ewhe7sjCmo+Dq2Vr+FZCixqNRaadcvAxtpFw@mail.gmail.com>
 <1362110504.15531.4@driftwood> <CAKgNAkgVKnhRT1Lpq4a_UdBKB+tn6XmWSDF2QJXG0aSLtNH6dg@mail.gmail.com>
 <1362369010.29250.3@driftwood>
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Date: Mon, 4 Mar 2013 13:50:02 +0100
Message-ID: <CAKgNAkiH+BTOpGd5nr7JU8mrYVNJE6oxiS-+YjKQxFkdsrR-jA@mail.gmail.com>
Subject: Re: For review: pid_namespaces(7) man page
To: Rob Landley <rob@landley.net>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        linux-man <linux-man@vger.kernel.org>,
        Linux Containers <containers@lists.linux-foundation.org>,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 4, 2013 at 4:50 AM, Rob Landley <rob@landley.net> wrote:
> On 03/01/2013 03:57:40 AM, Michael Kerrisk (man-pages) wrote:
>>
>> > And yet the glibc guys insist on #define GNU_GNU_GNU_ALL_HAIL_STALLMAN
>> > in
>> > order to access this Linux-specific feature which has nothing whatsoever
>> > to
>> > do with the FSF.
>>
>> This is a misunderstanding. _GNU_SOURCE is the standard way to expose
>> Linux-specific functionality from POSIX header files.
>
>
> What standard? The Linux kernel is not, and never was, part of the GNU
> project.

This is "the standard way that glibc isolates Linux-specific
functionality in POSIX header files".

Thanks,

Michael


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Author of "The Linux Programming Interface"; http://man7.org/tlpi/
