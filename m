Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756201AbaCNVPB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 17:15:01 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:45317 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755422AbaCNVO7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 17:14:59 -0400
Date: Fri, 14 Mar 2014 22:14:57 +0100
From: Pavel Machek <pavel@ucw.cz>
To: rjw@rjwysocki.net, linux-acpi@vger.kernel.org,
        kernel list <linux-kernel@vger.kernel.org>
Subject: 3.14-rc: /proc/acpi/battery gone?
Message-ID: <20140314211456.GA23213@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

It seems /proc/acpi/battery interface is gone, and I don't see any
option to reintroduce it... what is going on?

(I got into habit of archiving content of /proc/acpi/battery to
monitor, how battery ages..)

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
