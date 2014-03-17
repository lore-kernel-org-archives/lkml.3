Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932526AbaCQJbs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 05:31:48 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34714 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932210AbaCQJbq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 05:31:46 -0400
Date: Mon, 17 Mar 2014 10:31:44 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: linux-kernel@vger.kernel.org
Subject: [GIT] HID
Message-ID: <alpine.LNX.2.00.1403171028020.3690@pobox.suse.cz>
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



- fix for ordering of device removal actions in hidraw, by Fernando Luis 
  Vázquez Cao

- fix for uninitialized workqueue usage in hid-sony, by Frank Praznik

- signature addition for new variant of Logitech G27, from Simon Wood



Thanks.


Fernando Luis Vázquez Cao (1):
      HID: hidraw: fix warning destroying hidraw device files after parent

Frank Praznik (1):
      HID: sony: Fix work queue issues.

Simon Wood (1):
      HID: hid-lg4ff: Support new version of G27

 drivers/hid/hid-lg4ff.c |    2 ++
 drivers/hid/hid-sony.c  |   27 ++++++++++++---------------
 drivers/hid/hidraw.c    |    4 ++--
 3 files changed, 16 insertions(+), 17 deletions(-)

-- 
Jiri Kosina
SUSE Labs
