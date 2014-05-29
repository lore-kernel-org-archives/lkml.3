Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757817AbaE2QLG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 12:11:06 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:48745 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755646AbaE2QLD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 12:11:03 -0400
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <CAJfpeguyE0cg+RAEwOR89=qTGnr2OZFuhZ4tmAfkMLn5-DP_wg@mail.gmail.com>
References: <27993.1401360881@warthog.procyon.org.uk>
	<1400838223-30844-1-git-send-email-miklos@szeredi.hu>
	<28313.1401362925@warthog.procyon.org.uk>
	<20140529120734.GM17233@tucsk.piliscsaba.szeredi.hu>
	<CAJfpeguyE0cg+RAEwOR89=qTGnr2OZFuhZ4tmAfkMLn5-DP_wg@mail.gmail.com>
Date: Thu, 29 May 2014 18:10:57 +0200
Message-ID: <CA+icZUVU7RkyORehW8Z9SG6q8uzBPEes20MzZRxBWH=8qRx=DA@mail.gmail.com>
Subject: Re: Kernel errors with overlay filesystem v22
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: David Howells <dhowells@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Robo Bot <apw@canonical.com>, Felix Fietkau <nbd@openwrt.org>,
        Neil Brown <neilb@suse.de>, Jordi Pujol <jordipujolp@gmail.com>,
        ezk@fsl.cs.sunysb.edu, "J. R. Okajima" <hooanon05@yahoo.co.jp>,
        "mszeredi@suse.cz" <mszeredi@suse.cz>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 29, 2014 at 6:06 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> On Thu, May 29, 2014 at 2:07 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>> On Thu, May 29, 2014 at 12:28:45PM +0100, David Howells wrote:
>>>
>>> This sequence of commands produces both errors:
>
> Fixes pushed to overlayfs.v22 (and overlayfs.current).  Will
> eventually fold these into the main overlayfs patch.
>

So that people don't mix up the versions of current OverlayFS, please
rename the new baby "v23".
Thanks.

- Sedat -
