Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932759Ab3BNJGw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 04:06:52 -0500
Received: from mail-ia0-f171.google.com ([209.85.210.171]:59481 "EHLO
	mail-ia0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756446Ab3BNJGs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 04:06:48 -0500
MIME-Version: 1.0
In-Reply-To: <20130213222221.GA11235@windriver.com>
References: <20130213200432.GA11018@windriver.com>
	<201302132154.38477.linux@rainbow-software.org>
	<20130213222221.GA11235@windriver.com>
Date: Thu, 14 Feb 2013 10:06:48 +0100
Message-ID: <CACRpkdY23SsZ6nh5Gsi5VAds2OVgryNunu7azDJXQ+jCYa1jrw@mail.gmail.com>
Subject: Re: [GIT PULL] removal of 1980s PC-XT MFM 8bit ISA disk driver
From: Linus Walleij <linus.walleij@linaro.org>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Ondrej Zary <linux@rainbow-software.org>, Jens Axboe <axboe@kernel.dk>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 13, 2013 at 11:22 PM, Paul Gortmaker
<paul.gortmaker@windriver.com> wrote:

> But before doing that though, lets look at this rather contrived "fix"
> that coincidentally happened to appear after the deletion was suggested.

Hm. Haha, I had no idea that this driver was simultaneously being
considered for removal.

> 1) it claims the following: "...the fact that it was in the kernel tree
> SAVED MY DATA." [caps exactly as in original].  This is patently false,

I don't know what kind of debate you guys are having or what kind
of background there is in this discussion, but it's not like you're using
a welcoming tone to new contributors here.

Are you guys in the middle of some flamefest of the same type
as the inclusionist vs deletionist power-struggle they have over
at the Wikipedia every now and then?
http://en.wikipedia.org/wiki/Deletionism_and_inclusionism_in_Wikipedia

All I was doing was hacking some old hardware, and I was having fun,
while retrieveing some old pascal programs.

Compare the title of a book put out by some kernel developer a while
back.

Part of this mail seems to be something like review comments,
I recommend you send these as replies to the individual patches?

As for whether to delete or maintain the driver I do not really
care, what I know is that having it around was helpful and fun
for this one hacker here.

Yours,
Linus Walleij
