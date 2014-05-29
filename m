Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934314AbaE2Ro4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 13:44:56 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:50432 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932640AbaE2Roz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 13:44:55 -0400
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <29410.1401385296@warthog.procyon.org.uk>
References: <1400838223-30844-1-git-send-email-miklos@szeredi.hu>
	<28592.1401382081@warthog.procyon.org.uk>
	<CA+icZUXfzPsqZt6=o5evcQ2xO9XGKcMVYBO1zco0aEmGn_x0rA@mail.gmail.com>
	<29026.1401383705@warthog.procyon.org.uk>
	<CA+icZUWXjPR6wLk0+Dtmyr-VAHW2VMK-=MiZn8WX39F_qh+LHg@mail.gmail.com>
	<29191.1401384252@warthog.procyon.org.uk>
	<CA+icZUV64FQy4K7zx4B8NvwSXRgFfHZ_Y5D3A+zDAw9+XAwrxA@mail.gmail.com>
	<29410.1401385296@warthog.procyon.org.uk>
Date: Thu, 29 May 2014 19:44:53 +0200
Message-ID: <CA+icZUU-BcgbZ2b0-Nbu=9g57c5WTJV3Him29cDnpuOp5W62Sw@mail.gmail.com>
Subject: Re: Unionmount and overlayfs testsuite
From: Sedat Dilek <sedat.dilek@gmail.com>
To: David Howells <dhowells@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Al Viro <viro@zeniv.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>, apw@canonical.com,
        Felix Fietkau <nbd@openwrt.org>, neilb@suse.de, jordipujolp@gmail.com,
        ezk@fsl.cs.sunysb.edu, "J. R. Okajima" <hooanon05@yahoo.co.jp>,
        mszeredi@suse.cz
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 29, 2014 at 7:41 PM, David Howells <dhowells@redhat.com> wrote:
> Sedat Dilek <sedat.dilek@gmail.com> wrote:
>
>> >> /mnt/a/foo101: Test file not on upper filesystem  (line 30)
>> >
>> > Now check dmesg.
>> >
>>
>> [ 1384.995334] tmpfs: No value for mount option 'union'
>
> That's going down the unionmount testing route, it would appear.  You're
> definitely doing:
>
>         TEST_OVERLAYFS=1 ./run.sh
>
> right?
>

Yes (with my mount-patch applied).

( ...and... # umount /lower /upper /mnt )

- Sedat -
