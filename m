Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932866Ab3GQRDX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 13:03:23 -0400
Received: from mail-vc0-f176.google.com ([209.85.220.176]:36385 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932620Ab3GQRDV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 13:03:21 -0400
MIME-Version: 1.0
In-Reply-To: <20130717165743.GK8731@rric.localhost>
References: <20130710133742.GA29368@emu.suse.cz>
	<CA+55aFxtvT3Yvbxe5JGBThZS13payymFJ7jCLyEiE2iNDvsZtQ@mail.gmail.com>
	<20130711135445.GA21500@sepie.suse.cz>
	<CA+55aFyVjugxM7cUDWi0ASWttYthCxa6e7X3CADknBcSFxWgew@mail.gmail.com>
	<20130712105721.GF8731@rric.localhost>
	<20130717160506.GI8731@rric.localhost>
	<CA+55aFx4G5gME3ByqE0Wr-_t2x_6WkP3Ta4k1z4jfW+PrcK0og@mail.gmail.com>
	<20130717165743.GK8731@rric.localhost>
Date: Wed, 17 Jul 2013 10:03:20 -0700
X-Google-Sender-Auth: 97pbLnF9wXmvHChRfQlBwtBWg24
Message-ID: <CA+55aFzhmV7iq+Pv37trMCmdNzk53ORAoj0a6rV14fzKta3Dhw@mail.gmail.com>
Subject: Re: [PATCH] arm, kbuild: make "make install" not depend on vmlinux
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Robert Richter <rric@kernel.org>
Cc: Russell King <linux@arm.linux.org.uk>, Michal Marek <mmarek@suse.cz>,
        Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 17, 2013 at 9:57 AM, Robert Richter <rric@kernel.org> wrote:
>
> If kernel.release doen't exist KERNEL_RELEASE is empty, thus all args
> for install.sh shift one arg left.

You know what? I read the patch, but I didn't read your changelog well
enough. You already explained that in the commit log, and I just
missed it like some blind monkey. My bad.

> Will splitt the patches and resend.

No need to split, I was wrong, it wasn't some unrelated cleanup, and
you were right the first time.

So Michal (or ARM people - whoever wants to take the patch), just take
my ack. No objections.

                 Linus
