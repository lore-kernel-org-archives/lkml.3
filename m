Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752743Ab3IYV51 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 17:57:27 -0400
Received: from outpost1.zedat.fu-berlin.de ([130.133.4.66]:42527 "EHLO
	outpost1.zedat.fu-berlin.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750853Ab3IYV50 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 17:57:26 -0400
Date: Wed, 25 Sep 2013 23:57:21 +0200
From: Benjamin Valentin <benpicco@zedat.fu-berlin.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: STAGING SUBSYSTEM <devel@driverdev.osuosl.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] add exFAT driver
Message-ID: <20130925235721.12d2fcec@rechenknecht2k7>
In-Reply-To: <20130925172704.GB5258@kroah.com>
References: <20130830124622.5f81b7d4@rechenknecht2k7>
	<20130830154205.GA1411@kroah.com>
	<20130925183632.08a0d073@rechenknecht2k7>
	<20130925172704.GB5258@kroah.com>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.17; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Originating-IP: 77.186.48.189
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Wed, 25 Sep 2013 10:27:04 -0700
schrieb Greg Kroah-Hartman <gregkh@linuxfoundation.org>:

> > > Also, I would really like to get a signed-off-by: from the Samsung
> > > authors for this patch, can you do that as well please?
> > 
> > I've tried reaching them by their last public e-mail addresses I
> > could find, but they would either bounce or I got no reply.
> 
> Who did you contact at Samsung?  I'll be visiting there in a week so I
> can try to track some people done in person.  I really want their
> signed-off-by: on the patch, as it is their code to start with, and
> it's a bit rude to not get their approval for the code to be merged.

I didn't really know who to contact at Samsung, so I've searched the web
for Joosun Hahn and Sung-Kwan Kim. They both had addresses from the
Memory & Storage Architecture Lab at Seoul National University, but
they seem no longer active.
I've also tried the inquiry form on the Samsung web page, but got no
reply.

It'd be great if you could get Samsung to work on this too, I guess
they weren't originally so keen on mainlining it when it took the
Software Freedom Conservancy to get them to release the code [1],
but now that it's out in the open they might as well take the benefits
from mainline inclusion.

[1] http://sfconservancy.org/news/2013/aug/16/exfat-samsung/
