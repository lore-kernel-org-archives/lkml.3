Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754655AbaHEENd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 00:13:33 -0400
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:60397 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754581AbaHEENa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 00:13:30 -0400
Date: Tue, 5 Aug 2014 06:13:25 +0200
From: Andreas Mohr <andi@lisas.de>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Kristina =?utf-8?Q?Mart=C5=A1enko?= 
	<kristina.martsenko@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, devel@linuxdriverproject.org
Subject: Re: [GIT PULL] Staging driver patches for 3.17-rc1
Message-ID: <20140805041325.GA27507@rhlx01.hs-esslingen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140804190837.GA27292@kroah.com>
X-Priority: none
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Lots of things in here, over 2000 patches, but the best part is this:
>  1480 files changed, 39070 insertions(+), 254659 deletions(-)
>
> Thanks to the great work of Kristina Martšenko, 14 different staging
> drivers have been removed from the tree as they were obsolete and no
> one
> was willing to work on cleaning them up.

-ENOPARSE.

Define "as they were obsolete and no one was willing to work on cleaning
them up."?

*Either* they're obsolete (due to better alternatives available, in the
standard case), in which case they indeed can be removed on the spot,
*or* they are expected to become full-service drivers and thus need cleanup.
Which is it?

In the case of keucr (a driver where I happen to own hardware,
and where AFAIK this driver is required),
I really don't see "nobody was willing to work on cleaning them up.",
as git log tells. Admittedly there probably was no substantial rework,
but it did have many janitorial changes, and some changes
only 4 months ago even (a time frame which IMHO does not justify
removing a driver wholesale, with the effect of certain users to not be able to
use them then).

Oh well, yet another driver where it became more difficult rather than easier
to make forward progress.


But I guess that change was done very intentionally, likely to induce pain
in non-cooperative areas ;-P
(which may or may not be a good thing...)

Andreas Mohr
