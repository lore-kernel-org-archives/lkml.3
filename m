Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932129Ab3FLWWp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 18:22:45 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57889 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755220Ab3FLWWo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 18:22:44 -0400
Date: Thu, 13 Jun 2013 00:22:42 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT] HID
Message-ID: <alpine.LNX.2.00.1306130021140.6750@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

please pull from

  git://git.kernel.org/pub/scm/linux/kernel/git/jikos/hid.git for-linus

to receive


- memory leak regression fix from Benjamin Tissoires.


Thanks.

Benjamin Tissoires (1):
      HID: multitouch: prevent memleak with the allocated name

 drivers/hid/hid-multitouch.c |   11 +++++++----
 1 files changed, 7 insertions(+), 4 deletions(-)

-- 
Jiri Kosina
SUSE Labs
