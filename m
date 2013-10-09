Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755221Ab3JIUJm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 16:09:42 -0400
Received: from mail-lb0-f176.google.com ([209.85.217.176]:63992 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752606Ab3JIUJj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 16:09:39 -0400
MIME-Version: 1.0
In-Reply-To: <8761t65kd2.fsf_-_@xmission.com>
References: <CAJfpegsxgnSRUW-E5HM3uT5QfGyUtn_v=i4Ppkkkutp34287AA@mail.gmail.com>
 <87a9kkax0j.fsf@xmission.com> <CAJfpeguv+7giYNpAuXE9Ja_9BEwB0-fZBVgRSeVqpzSXgQYZ6Q@mail.gmail.com>
 <8761v7h2pt.fsf@tw-ebiederman.twitter.com> <CAJfpegtT7y-1HhbEVAMKkdQugTG_w7G_epGtQHGvQLpcZB5FVA@mail.gmail.com>
 <87li281wx6.fsf_-_@xmission.com> <874n8w1wsz.fsf_-_@xmission.com>
 <20131008155041.GI14242@tucsk.piliscsaba.szeredi.hu> <877gdne8pr.fsf@xmission.com>
 <8761t65kd2.fsf_-_@xmission.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 9 Oct 2013 13:09:17 -0700
Message-ID: <CALCETrUqXTj7T_bYOgwMiO_kcU=NPD_+ck+Z=JsmXuUJJGshuQ@mail.gmail.com>
Subject: Re: Grrrr fusermount.
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, "Serge E. Hallyn" <serge@hallyn.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Rob Landley <rob@landley.net>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 9, 2013 at 12:12 PM, Eric W. Biederman
<ebiederm@xmission.com> wrote:
> ebiederm@xmission.com (Eric W. Biederman) writes:
>
>> But I will go through and read the old fusermount code before I get too
>> much farther just so I understand what I am potentially breaking.
>
> Grr.
>
> So I have just read the fusermount umount code and the hack that it uses
> before there was UMOUNT_NOFOLLOW support in the vm.
>
> If I walk this path of lazy unmounts and detaching directories, anyone
> with a new kernel and an old copy of fusermount and a nfs mounted home
> directory will be able to exploit the fusermount umount symlink race.
>
> Unless we can declare that old fusermount binaries are buggy beyond
> supporting this patchset as it exists is dead.

What's the hack that it does?

--Andy
