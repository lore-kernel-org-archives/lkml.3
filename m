Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933066Ab3GCQJt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 12:09:49 -0400
Received: from mail-vc0-f170.google.com ([209.85.220.170]:61574 "EHLO
	mail-vc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755068Ab3GCQJr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 12:09:47 -0400
MIME-Version: 1.0
In-Reply-To: <20130703113520.GA21189@thunk.org>
References: <nsxbo6mxu38.fsf@lambda.thunk.org>
	<CA+55aFyRLc81s03ULLZ26N0qwRqxS-9+6XpyhxVH62qx2b5o2A@mail.gmail.com>
	<20130702180447.GB16282@quack.suse.cz>
	<20130703113520.GA21189@thunk.org>
Date: Wed, 3 Jul 2013 09:09:46 -0700
X-Google-Sender-Auth: wOU7N_0JYRl2D9equx0CZjykKms
Message-ID: <CA+55aFzK0fZ6ZM=m8UuDNMF74qeunus_ztrjuvddgXG=Ehbr5w@mail.gmail.com>
Subject: Re: [GIT PULL] ext4 updates for 3.11
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Theodore Ts'o" <tytso@mit.edu>, Jan Kara <jack@suse.cz>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 3, 2013 at 4:35 AM, Theodore Ts'o <tytso@mit.edu> wrote:
>
> Linus, are you in a hurry to get this fixed up?  I

No, I just hate seeing warnings in my (simplified) standard build. I'm
used to them in the "allmodconfig" builds I do, but prefer to not see
them when I just build a localized kernel.

But it's not critical. Just as long as I know it will get fixed, I'm happy.

             Linus
