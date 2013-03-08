Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755125Ab3CHKeH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 05:34:07 -0500
Received: from cantor2.suse.de ([195.135.220.15]:48865 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752302Ab3CHKeF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 05:34:05 -0500
Date: Fri, 8 Mar 2013 11:34:03 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT] HID
Message-ID: <alpine.LNX.2.00.1303081126230.19460@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

please pull from

  git://git.kernel.org/pub/scm/linux/kernel/git/jikos/hid.git for-3.9/upstream-fixes

to receive


Bugfix for a long-standing bug in logitech-dj driver causing all sorts of 
random initialization problems, finally debugged by Benjamin Tissoires 
with help of Bob Bowles.


Benjamin Tissoires (1):
      HID: logitech-dj: do not directly call hid_output_raw_report() during probe

 drivers/hid/hid-logitech-dj.c |   22 ++++++++++++++--------
 1 files changed, 14 insertions(+), 8 deletions(-)

-- 
Jiri Kosina
SUSE Labs
