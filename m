Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755454Ab3GUDQX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jul 2013 23:16:23 -0400
Received: from mail-ea0-f182.google.com ([209.85.215.182]:65334 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754892Ab3GUDQW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jul 2013 23:16:22 -0400
MIME-Version: 1.0
In-Reply-To: <20130721024511.GC21484@thunk.org>
References: <20130717161944.GA19405@redhat.com>
	<20130719121405.GA3856@gmail.com>
	<20130719233613.GH4165@ZenIV.linux.org.uk>
	<20130721024511.GC21484@thunk.org>
Date: Sat, 20 Jul 2013 20:16:19 -0700
X-Google-Sender-Auth: F4rlzuVy3D7EgsDmpqVzomeqy8Y
Message-ID: <CA+55aFz+sSGk_QSA0HLvpGQAOLfP=V=HKDVXVgEkyuevqMOW3w@mail.gmail.com>
Subject: Re: [GIT PULL] Re: [PATCH] ext4: fix a bug when we try to open a file
 with O_TMPFILE flag
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Theodore Ts'o" <tytso@mit.edu>, Al Viro <viro@zeniv.linux.org.uk>,
        Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 20, 2013 at 7:45 PM, Theodore Ts'o <tytso@mit.edu> wrote:
>
> On second thought, to avoid an "After you, Alphonse" moment, and
> because it would be really good to make sure these patches make it to
> Linus before -rc2, I thought get these patches set up for a pull
> request.  Al, if you'd prefer that they go through the vfs tree, feel
> free to NACK this, and I'll happily drop these from the ext4 tree.

Since you applied this on top the the last vfs pull, the example
programs in the commit logs are now incorrect (you need O_TEMPFILE |
O_RDWR or similar these days), but I guess the intent is clear anyway.

Pulled.

         Linus
