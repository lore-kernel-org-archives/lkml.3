Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750916Ab3CWLkW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Mar 2013 07:40:22 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:39651 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750708Ab3CWLkU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Mar 2013 07:40:20 -0400
Date: Sat, 23 Mar 2013 12:40:12 +0100
From: Pavel Machek <pavel@ucw.cz>
To: kernel list <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, lenb@kernel.org,
        linux-acpi@vger.kernel.org
Subject: 3.9-rc3+: reports battery as 0 mWh capacity on thinkpad x60
Message-ID: <20130323114011.GA11092@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

pavel@amd:~$ cat /proc/acpi/battery/BAT0/info 
present:                 yes
design capacity:         0 mWh
last full capacity:      0 mWh
battery technology:      rechargeable
design voltage:          14400 mV

This worked before... at least it works in 2.6 kernel used by debian.

          	    	      	       	  	       	      	      Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
