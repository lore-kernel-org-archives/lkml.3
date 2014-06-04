Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753147AbaFDIM1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 04:12:27 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:56029 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751323AbaFDIMZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 04:12:25 -0400
Date: Wed, 4 Jun 2014 10:12:23 +0200
From: Pavel Machek <pavel@ucw.cz>
To: kernel list <linux-kernel@vger.kernel.org>
Subject: regression: chromium: your profile could not be opened correctly
Message-ID: <20140604081223.GA19645@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

I'm not 100% sure, but it seems above error happens with newer kernels
(like 3.15), but not with older ones (like 3.10).

Unfortunately, it happens "sometimes" :-(.

Any ideas? Did anyone else seen that?

It seems to go away after reboot.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
