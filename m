Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753243AbaFMKoi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 06:44:38 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:50726 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752348AbaFMKoh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 06:44:37 -0400
Date: Fri, 13 Jun 2014 12:44:35 +0200
From: Pavel Machek <pavel@ucw.cz>
To: kernel list <linux-kernel@vger.kernel.org>
Cc: johannes.berg@intel.com, emmanuel.grumbach@intel.com, ilw@linux.intel.com,
        linux-wireless@vger.kernel.org
Subject: iwlwifi: very poor performance on 3.16-rc0
Message-ID: <20140613104435.GA4689@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

On 6d87c225f5d82d29243dc124f1ffcbb0e14ec358 I get basically unusable
network.

Network manager connects to wireless network, and ping sometimes
returns a packet. One in 10 tabs load, dns usually does not work.

Thinkpad x60, 

03:00.0 Network controller: Intel Corporation PRO/Wireless 3945ABG
[Golan] Network Connection (rev 02)

Any ideas?
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
