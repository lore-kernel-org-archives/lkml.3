Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758277Ab3DAOXj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 10:23:39 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:49557 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758212Ab3DAOXi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 10:23:38 -0400
Date: Mon, 1 Apr 2013 16:23:36 +0200
From: Pavel Machek <pavel@denx.de>
To: sr@denx.de, w.sang@pengutronix.de, magnus.damm@gmail.com,
        hjk@linutronix.de, Greg KH <greg@kroah.com>,
        kernel list <linux-kernel@vger.kernel.org>, dzu@denx.de
Subject: UIO device tree bindings.
Message-ID: <20130401142336.GA18034@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

I'd like to get uio device tree bindings to work -- with recent FPGA
parts it will be important. Latest version I see is 

https://lists.ozlabs.org/pipermail/linuxppc-dev/2009-June/073087.html

... Is there anything newer?

I red the discussion, and main problem seems to be the "tell kernel to
drive this device tree device", right?

Also I feel like there will be some fun testing it. Does anyone have
ideas?

Thanks,
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
