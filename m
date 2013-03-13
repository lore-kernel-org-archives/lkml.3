Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754877Ab3CMJml (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 05:42:41 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:47198 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753833Ab3CMJmj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 05:42:39 -0400
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <20130312222350.GK21522@ZenIV.linux.org.uk>
References: <1363102908-28956-1-git-send-email-miklos@szeredi.hu>
	<CA+55aFzRzwJs1qwjhBstAQzXC0rqn5COM6-7cgD3UsygSvTQ-Q@mail.gmail.com>
	<20130312222350.GK21522@ZenIV.linux.org.uk>
Date: Wed, 13 Mar 2013 10:42:37 +0100
Message-ID: <CA+icZUXxfFXdqsS-s=WQJ+3XBNA7TYJjPUWAWAvcU0L9bhQoDA@mail.gmail.com>
Subject: Re: [PATCH 00/13] overlay filesystem: request for inclusion (v16)
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Al Viro <viro@zeniv.linux.org.uk>, Miklos Szeredi <miklos@szeredi.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Robo Bot <apw@canonical.com>, Felix Fietkau <nbd@openwrt.org>,
        Neil Brown <neilb@suse.de>, Jordi Pujol <jordipujolp@gmail.com>,
        ezk@fsl.cs.sunysb.edu, David Howells <dhowells@redhat.com>,
        Sedat Dilek <sedat.dilek@googlemail.com>,
        "J. R. Okajima" <hooanon05@yahoo.co.jp>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 12, 2013 at 11:23 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Tue, Mar 12, 2013 at 02:50:02PM -0700, Linus Torvalds wrote:
>> On Tue, Mar 12, 2013 at 8:41 AM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>> > Al and Linus,
>> >
>> > Please consider overlayfs for inclusion into 3.10.
>>
>> Yes, I think we should just do it. It's in use, it's pretty small, and
>> the other alternatives are worse. Let's just plan on getting this
>> thing done with.
>>
>> Al, I realize you may not love this, but can you please give this a
>> look? People clearly want to use it. In particular the new interfaces,
>> like the inode ops open function with dentry passed in or whatever?
>> The changes outside of overlayfs looked fine to me.
>
> I'll post a review tonight or tomorrow.  FWIW, I was not too happy with
> it the last time I looked, but I'll obviously need to reread the whole
> thing.
>
> I *have* looked at unionmount lately, and the recent modifications dhowells
> is doing there are closing most of my problems with that; on the other hand,
> there's no fundamental reason why both can't get merged.  Hell, might as
> well resurrect aufs, while we are at it...
>
> union-like things are actually on top of my "things to deal with this cycle"
> list, closely folowed by rework of ->readdir().
>
> Miklos, two points:
>         * I would very much prefer to deal with that (as well as unionmount and
> aufs) as git branches _expected_ to be reordered/rebased/folded/mutilated/etc.
> while we are sorting all that stuff out.  For now, let's base them on -rc1.
> I expect that vfs.git will grow common stem, with bits and pieces of those
> guys getting gradually pulled into it, at which point(s) the rest will be
> rebased.
>         * what Linus just said about bisectablity
> Oh, and the third one - I still owe you a bottle of your choice for sorting
> the atomic_open shite out.  Is there any chance you'll be able to attend
> LSFS this year?
>

Hi all,

I only say: Al-lelujah!

Congrats Miklos!

- Sedat -

> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
