Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757265AbaE2QGT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 12:06:19 -0400
Received: from mail-qg0-f45.google.com ([209.85.192.45]:60306 "EHLO
	mail-qg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756207AbaE2QGQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 12:06:16 -0400
MIME-Version: 1.0
X-Originating-IP: [46.139.80.5]
In-Reply-To: <20140529120734.GM17233@tucsk.piliscsaba.szeredi.hu>
References: <27993.1401360881@warthog.procyon.org.uk>
	<1400838223-30844-1-git-send-email-miklos@szeredi.hu>
	<28313.1401362925@warthog.procyon.org.uk>
	<20140529120734.GM17233@tucsk.piliscsaba.szeredi.hu>
Date: Thu, 29 May 2014 18:06:15 +0200
Message-ID: <CAJfpeguyE0cg+RAEwOR89=qTGnr2OZFuhZ4tmAfkMLn5-DP_wg@mail.gmail.com>
Subject: Re: Kernel errors with overlay filesystem v22
From: Miklos Szeredi <miklos@szeredi.hu>
To: David Howells <dhowells@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Robo Bot <apw@canonical.com>, Felix Fietkau <nbd@openwrt.org>,
        Neil Brown <neilb@suse.de>, Jordi Pujol <jordipujolp@gmail.com>,
        ezk@fsl.cs.sunysb.edu, Sedat Dilek <sedat.dilek@gmail.com>,
        "J. R. Okajima" <hooanon05@yahoo.co.jp>,
        "mszeredi@suse.cz" <mszeredi@suse.cz>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 29, 2014 at 2:07 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> On Thu, May 29, 2014 at 12:28:45PM +0100, David Howells wrote:
>>
>> This sequence of commands produces both errors:

Fixes pushed to overlayfs.v22 (and overlayfs.current).  Will
eventually fold these into the main overlayfs patch.

Thanks,
Miklos
