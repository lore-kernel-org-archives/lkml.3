Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755977AbaE2TYe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 15:24:34 -0400
Received: from mail-wg0-f49.google.com ([74.125.82.49]:36034 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751011AbaE2TYc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 15:24:32 -0400
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <32659.1401391220@warthog.procyon.org.uk>
References: <1400838223-30844-1-git-send-email-miklos@szeredi.hu>
	<28592.1401382081@warthog.procyon.org.uk>
	<CA+icZUXfzPsqZt6=o5evcQ2xO9XGKcMVYBO1zco0aEmGn_x0rA@mail.gmail.com>
	<29026.1401383705@warthog.procyon.org.uk>
	<CA+icZUWXjPR6wLk0+Dtmyr-VAHW2VMK-=MiZn8WX39F_qh+LHg@mail.gmail.com>
	<29191.1401384252@warthog.procyon.org.uk>
	<CA+icZUV64FQy4K7zx4B8NvwSXRgFfHZ_Y5D3A+zDAw9+XAwrxA@mail.gmail.com>
	<29410.1401385296@warthog.procyon.org.uk>
	<CA+icZUU-BcgbZ2b0-Nbu=9g57c5WTJV3Him29cDnpuOp5W62Sw@mail.gmail.com>
	<31766.1401387746@warthog.procyon.org.uk>
	<CA+icZUWUjkp4kpsXZg+UeW5UbWU0D_aDKzh2S9_JYeLhNaWgFg@mail.gmail.com>
	<CA+icZUWo9eD=0KqVapZ_2vWZfWrrSWauaXMRNvkmdy+4cXgAig@mail.gmail.com>
	<32659.1401391220@warthog.procyon.org.uk>
Date: Thu, 29 May 2014 21:24:31 +0200
Message-ID: <CA+icZUUS-cgeogyR7h_bFhe2YCiNB+sLZy1E5VcceQeS_Jkxpg@mail.gmail.com>
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

On Thu, May 29, 2014 at 9:20 PM, David Howells <dhowells@redhat.com> wrote:
> Sedat Dilek <sedat.dilek@gmail.com> wrote:
>
>> Hmm, why is the generated binary callled "open-file" and in the
>> scripts I see "open_file"?
>
> grep is your friend:-)  Look in tool_box.inc
>

I resetted to origin/HEAD and still get...

# LC_ALL=C TEST_OVERLAYFS=1 ./run.sh
***
*** ./run.sh open-plain.test
***
TEST100: Open O_RDONLY
 - open_file -r /mnt/a/foo100 -R :xxx:yyy:zzz
 - open_file -r /mnt/a/foo100 -R :xxx:yyy:zzz
TEST101: Open O_WRONLY
 - open_file -w /mnt/a/foo101 -W q
/mnt/a/foo101: Test file not on upper filesystem  (line 30)

- Sedat -
