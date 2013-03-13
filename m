Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934179Ab3CMT7A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 15:59:00 -0400
Received: from mail-vb0-f50.google.com ([209.85.212.50]:34442 "EHLO
	mail-vb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933201Ab3CMT67 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 15:58:59 -0400
MIME-Version: 1.0
In-Reply-To: <87k3pbhy7o.fsf@xmission.com>
References: <1363184193-1796-1-git-send-email-miklos@szeredi.hu>
	<CA+icZUVLsqXNEc4UTQp0dDG21sQb0xtFMDF9Lyq5Jy7Px0pPBQ@mail.gmail.com>
	<CA+icZUVn=3qcEDchYqUf2JqDBfPsN6Zxh+cJCDbUaOrkjg7uJg@mail.gmail.com>
	<CAJfpegu40UMTfofY0L20T69sqmPrvpCP53N-xzumgX5MrAZuJw@mail.gmail.com>
	<CA+icZUV=XoN=uUn7npU9Djnkr5DEuA0D42=HV_1n6WN4v2rQMA@mail.gmail.com>
	<CA+icZUXXrarmm3hYSxt7T2_sw+pmZycdmop5z4QCJ6=vMny9EQ@mail.gmail.com>
	<CA+icZUXzYGRU7deUyzgNBEfSkZf+-w6VLOewd+7R=RmZ21mTUg@mail.gmail.com>
	<CAJfpegu3cHatcoWYyYeA-w0+mtQUgiAVkqUOjLGrq9oxk7CcrQ@mail.gmail.com>
	<CA+icZUWqd4OfjxBKeOjqaPiVXOvBk9kLu1u1X_hiG9sbz1Eneg@mail.gmail.com>
	<20130313181251.GA6023@sgi.com>
	<5140C77E.7030206@openwrt.org>
	<CA+icZUUPTryfL9S2vHopPTcRkhV=Qxd1w_fh0mWbPrUE7Lw=zQ@mail.gmail.com>
	<87k3pbhy7o.fsf@xmission.com>
Date: Wed, 13 Mar 2013 12:58:58 -0700
X-Google-Sender-Auth: Y4qPE7vYw7mS9RAlJXgL2qGHy6Q
Message-ID: <CA+55aFyawa76qCrCXnjYRf=U8xcEwV2UrqNV_J0Z-rVDrSgsHg@mail.gmail.com>
Subject: Re: [PATCH 0/9] overlay filesystem: request for inclusion (v17)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Sedat Dilek <sedat.dilek@gmail.com>, Felix Fietkau <nbd@openwrt.org>,
        Robin Holt <holt@sgi.com>, Miklos Szeredi <miklos@szeredi.hu>,
        Al Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Robo Bot <apw@canonical.com>, Neil Brown <neilb@suse.de>,
        Jordi Pujol <jordipujolp@gmail.com>, ezk@fsl.cs.sunysb.edu,
        David Howells <dhowells@redhat.com>,
        Sedat Dilek <sedat.dilek@googlemail.com>,
        "J. R. Okajima" <hooanon05@yahoo.co.jp>,
        Miklos Szeredi <mszeredi@suse.cz>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 13, 2013 at 12:54 PM, Eric W. Biederman
<ebiederm@xmission.com> wrote:
>>
>> Hehe, I just checked my new kernel... that does not work (nothing in the logs).
>> But I think it's good to see if the filesystem is registered/loaded.
>
> lsmod | grep overlayfs

How about the compiled-in case? What's wrong with just using the
obvious /proc/filesystems?

             Linus
