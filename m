Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754354AbaKXSbf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 13:31:35 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:47148 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751930AbaKXSbd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 13:31:33 -0500
Date: Mon, 24 Nov 2014 19:31:30 +0100
From: Pavel Machek <pavel@ucw.cz>
To: pali.rohar@gmail.com, sre@debian.org, sre@ring0.de,
        kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-omap@vger.kernel.org, tony@atomide.com, khilman@kernel.org,
        aaro.koskinen@iki.fi, freemangordon@abv.bg
Subject: v3.18-rc1: n900 battery discharged down to 2.97V
Message-ID: <20141124183130.GA2927@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

I left the machine on usb-networking for extended period of
time. Unfortunately, Xfce screensaver kept screen busy, and kernel
failed to kill the machine.

At the end, hardware protections worked (I guess), but result is
battery discharged down to 2.97V.

Best regards,
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
