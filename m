Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933831Ab3CMPYf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 11:24:35 -0400
Received: from mail-la0-f45.google.com ([209.85.215.45]:60158 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933782Ab3CMPYc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 11:24:32 -0400
MIME-Version: 1.0
X-Originating-IP: [188.6.195.195]
In-Reply-To: <20130312222350.GK21522@ZenIV.linux.org.uk>
References: <1363102908-28956-1-git-send-email-miklos@szeredi.hu>
	<CA+55aFzRzwJs1qwjhBstAQzXC0rqn5COM6-7cgD3UsygSvTQ-Q@mail.gmail.com>
	<20130312222350.GK21522@ZenIV.linux.org.uk>
Date: Wed, 13 Mar 2013 16:24:30 +0100
Message-ID: <CAJfpegv2mV7W-vBYQ5KAwdRnUzkaZzb_QDB_Y-fortxjhsQiFw@mail.gmail.com>
Subject: Re: [PATCH 00/13] overlay filesystem: request for inclusion (v16)
From: Miklos Szeredi <miklos@szeredi.hu>
To: Al Viro <viro@zeniv.linux.org.uk>
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
> I'll post a review tonight or tomorrow.  FWIW, I was not too happy with
> it the last time I looked, but I'll obviously need to reread the whole
> thing.
>
> I *have* looked at unionmount lately, and the recent modifications dhowells
> is doing there are closing most of my problems with that; on the other hand,
> there's no fundamental reason why both can't get merged.  Hell, might as
> well resurrect aufs, while we are at it...

I haven't seen the union mount patchset for a long time.   David, do
you plan to send out the series for review sometime?

> Oh, and the third one - I still owe you a bottle of your choice for sorting
> the atomic_open shite out.  Is there any chance you'll be able to attend
> LSFS this year?

Can't make it this year.  But I do plan to go to KS in Edinburgh.

Thanks,
Miklos
