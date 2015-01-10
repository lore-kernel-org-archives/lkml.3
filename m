Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753507AbbAJRjY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2015 12:39:24 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:38676 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751585AbbAJRjX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2015 12:39:23 -0500
Date: Sat, 10 Jan 2015 18:39:20 +0100
From: Pavel Machek <pavel@ucw.cz>
To: pali.rohar@gmail.com, sre@debian.org, sre@ring0.de,
        kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        khilman@kernel.org, aaro.koskinen@iki.fi, ivo.g.dimitrov.75@gmail.com,
        Greg KH <greg@kroah.com>
Subject: Getting new udev to run with 2.6.28
Message-ID: <20150110173920.GA31847@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

N900 has real problems on 3.19, and 2.6.28 should be very well
debugged version. Getting it to compile on recent distribution was
fun, but I succeeded. Unfortunately, Debian 7's udev does not work
with 2.6.28...

Does anyone have kernel patches to enable modern udev?

Thanks,
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
