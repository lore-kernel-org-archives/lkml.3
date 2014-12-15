Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751557AbaLOLwA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 06:52:00 -0500
Received: from 251.110.2.81.in-addr.arpa ([81.2.110.251]:42730 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750873AbaLOLv7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 06:51:59 -0500
Date: Mon, 15 Dec 2014 11:51:47 +0000
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Loic Pefferkorn <loic@loicp.eu>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: staging: goldfish: Fix minor coding style
Message-ID: <20141215115147.3d4333e5@lxorguk.ukuu.org.uk>
In-Reply-To: <20141213212051.GB6979@iron>
References: <e2a3b3ccf85790c865683832698908458931be6a.1418487651.git.loic@loicp.eu>
	<20141213190705.0faaf119@lxorguk.ukuu.org.uk>
	<20141213212051.GB6979@iron>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.24; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 13 Dec 2014 22:20:52 +0100
Loic Pefferkorn <loic@loicp.eu> wrote:

> On Sat, Dec 13, 2014 at 07:07:05PM +0000, One Thousand Gnomes wrote:
> > 
> > Pointless churn. It makes it less readable if anything, and it removes
> > the type safety as you are now checking against 0 not (void *)0
> > 
> > NAK
> > 
> > Alan
> 
> The type safety is an interesting point I was not aware of.
> 
> Just in case, do you have something for me on your todo list?

Depends what you feel confident tackling. An interesting but
challenging one to look at as a newcomer might be

https://bugzilla.kernel.org/show_bug.cgi?id=87951

because it provides you with an example .iso file you can loopback mount
to see the crash, and the same fixes were done for a similar bug so can
be seen in the git log to work from.

commit 410dd3cf4c9b36f27ed4542ee18b1af5e68645a4

It's predictable, it's repeatable and it can be done crashing a virtual
machine not a real one. That usually makes things eaiser to fix.

For something easier perhaps

https://bugzilla.kernel.org/show_bug.cgi?id=75111

which just needs the configuration help fixing

Alan
