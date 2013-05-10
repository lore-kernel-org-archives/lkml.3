Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757407Ab3EJPRm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 11:17:42 -0400
Received: from cantor2.suse.de ([195.135.220.15]:59520 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757145Ab3EJPRi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 11:17:38 -0400
Date: Fri, 10 May 2013 17:17:34 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT] HID
Message-ID: <alpine.LNX.2.00.1305101713380.23038@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

please pull from

  git://git.kernel.org/pub/scm/linux/kernel/git/jikos/hid.git for-linus

to receive


- fix usage of sleeping lock in atomic context from Jiri Kosina

- build fix for hid-steelseries under certain .config setups by Simon Wood

- simple mismerge fix from Fernando Luis Vázquez Cao


Thanks.

Fernando Luis Vázquez Cao (1):
      HID: reintroduce fix-up for certain Sony RF receivers

Jiri Kosina (1):
      HID: debug: fix RCU preemption issue

Simon Wood (1):
      HID: hid-steelseries fix led class build issue

 drivers/hid/hid-core.c        |    3 ++-
 drivers/hid/hid-debug.c       |   15 +++++++++------
 drivers/hid/hid-steelseries.c |    9 ++++++---
 include/linux/hid.h           |    2 +-
 4 files changed, 18 insertions(+), 11 deletions(-)

-- 
Jiri Kosina
SUSE Labs
