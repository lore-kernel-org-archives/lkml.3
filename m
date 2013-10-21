Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753690Ab3JUNoT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 09:44:19 -0400
Received: from gherkin.frus.com ([192.158.254.49]:48807 "EHLO gherkin.frus.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752723Ab3JUNoS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 09:44:18 -0400
X-Greylist: delayed 1530 seconds by postgrey-1.27 at vger.kernel.org; Mon, 21 Oct 2013 09:44:18 EDT
Date: Mon, 21 Oct 2013 08:18:46 -0500
From: Bob Tracy <rct@gherkin.frus.com>
To: linux-kernel@vger.kernel.org
Subject: [BUG] 3.12.0-rcX IPv6 panic
Message-ID: <20131021131846.GA5769@gherkin.frus.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Actually, a regression: the 3.11 kernel is rock-solid stable on my
Alpha.

Beginning with 3.12.0-rc1, I can reliably trigger a kernel panic by
executing the gogo6.net "gw6c" IPv6 client program.  If the networking
layer is active, an "Oops" will eventually (within a day) occur regardless
of whether I attempt to run "gw6c".  3.12.0-rcX is stable as long as I
leave networking completely disabled.  The error has persisted up through
-rc6.  Apologies for not mentioning this earlier, but the state of my
PWS-433au has been questionable, and I wanted to make sure I had a
legitimate bug sighting.

I'll have to transcribe the panic backtrace by hand: nothing makes it
into any of the system logs :-(.  I *can* recall that every backtrace
I've seen thus far has included one of the skb_copy() variants near the
top of the list (first or second function).

--Bob
