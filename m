Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756041Ab3KWBIN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 20:08:13 -0500
Received: from mail-ve0-f174.google.com ([209.85.128.174]:38690 "EHLO
	mail-ve0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755826Ab3KWBIJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 20:08:09 -0500
MIME-Version: 1.0
In-Reply-To: <20131123004340.GA22310@srcf.ucam.org>
References: <CA+55aFxK5hkhteiL5cyPtHX5reup6aOiHQTCDKKdBsHiWsroGA@mail.gmail.com>
	<20131123004340.GA22310@srcf.ucam.org>
Date: Fri, 22 Nov 2013 17:08:08 -0800
X-Google-Sender-Auth: LRaeRpe-vt-Sj5A1aQgS1VuFrVk
Message-ID: <CA+55aFxEguBBH5B9J9=FLvph5EkLSOjzKc99hHpEDrRgkNHvZg@mail.gmail.com>
Subject: Re: Linux 3.13-rc1 is out
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 22, 2013 at 4:43 PM, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
>
> I'd sent a pull yesterday (http://lkml.org/lkml/2013/11/21/599 ) which
> may have missed your cutoff, but it seems worth checking.

No, it didn't miss my cutoff, and it wasn't even eaten by the gmail
spam filters, but it *had* missed my normal pattern for checking that
I had merged all git pull requests, which is why I had overlooked it.

Pulled now (going through the allmodconfig build test before being
pushed out shortly).

Btw, the reason it missed my normal check is that I search for
"in:inbox git pull" as a sanity check that I don't have anything
pending. Now, *most* of the time I tend to catch things regardless
just by virtue of reading email carefully, but when I'm busy it
definitely helps if your email matches that pattern.

The easiest (and most common) way to do that is to have the subject
line be something like

    [GIT PULL] sound fixes #2 for 3.13-rc1

but there are other patterns. For example, David Miller tends to have
instead a subject line like

    [GIT] Networking

and then "Please pull" in the body of the email. So the "in:inbox git
pull" thing basically catches pretty much everybody.

Except for you...

You use David Miller's subject line, but you don't have the "please
pull" part, so your email missed my "did I pull everything that I had
pending" check.

For very similar reasons, for people sending me a patch, it really
*really* helps if there's a "[patch]" (possibly with a n/m number
pattern) in the subject line..  Or make sure you send me a git diff,
because I also tend to search for the string "diff --git". Of course,
the main person who sends me patches is Andrew Morton, so I mostly
just search for "from:akpm" :)

               Linus
