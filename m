Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757267Ab3CDMtL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 07:49:11 -0500
Received: from mail-da0-f42.google.com ([209.85.210.42]:58057 "EHLO
	mail-da0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756407Ab3CDMtJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 07:49:09 -0500
MIME-Version: 1.0
Reply-To: mtk.manpages@gmail.com
In-Reply-To: <876217olp0.fsf@xmission.com>
References: <CAKgNAki=mUYuu_Ewhe7sjCmo+Dq2Vr+FZCixqNRaadcvAxtpFw@mail.gmail.com>
 <1362110504.15531.4@driftwood> <CAKgNAkgVKnhRT1Lpq4a_UdBKB+tn6XmWSDF2QJXG0aSLtNH6dg@mail.gmail.com>
 <1362369010.29250.3@driftwood> <876217olp0.fsf@xmission.com>
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Date: Mon, 4 Mar 2013 13:48:48 +0100
Message-ID: <CAKgNAkhyu6G_X5Smkq02a6GU7FcLQ1rR+e7f+KK4ruUy5-Z6AQ@mail.gmail.com>
Subject: Re: For review: pid_namespaces(7) man page
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Rob Landley <rob@landley.net>, linux-man <linux-man@vger.kernel.org>,
        Linux Containers <containers@lists.linux-foundation.org>,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 4, 2013 at 5:03 AM, Eric W. Biederman <ebiederm@xmission.com> wrote:
> Rob Landley <rob@landley.net> writes:
>
>> On 03/01/2013 03:57:40 AM, Michael Kerrisk (man-pages) wrote:
>>> > And yet the glibc guys insist on #define
>>> GNU_GNU_GNU_ALL_HAIL_STALLMAN in
>>> > order to access this Linux-specific feature which has nothing
>>> whatsoever to
>>> > do with the FSF.
>>>
>>> This is a misunderstanding. _GNU_SOURCE is the standard way to expose
>>> Linux-specific functionality from POSIX header files.
>>
>> What standard? The Linux kernel is not, and never was, part of the GNU
>> project.
>
> Is the argument that there should be a _LINUX_SOURCE directive in glibc
> for this?
>
> Although come to think of it I can't imagine how <sched.h> is a POSIX
> header.  Last I looked it only had linux specific bits in it.  Which
> makes needing any kind of #define strange.

I think you may be thinking of the wrong sched.h. The glibc
/usr/include/sched.h declares many user-space functions from POSIX.


Cheers,

Mcihael
