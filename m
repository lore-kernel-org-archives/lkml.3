Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967749Ab3HINYm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 09:24:42 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60582 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966645Ab3HINYl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 09:24:41 -0400
Date: Fri, 9 Aug 2013 15:24:37 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT] HID
Message-ID: <alpine.LNX.2.00.1308091522590.13089@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

please pull from

  git://git.kernel.org/pub/scm/linux/kernel/git/jikos/hid.git for-linus

to receive:


- revert of a patch which breaks enumeration workaround in hid-logitech-dj


Jiri Kosina (1):
      Revert "HID: hid-logitech-dj: querying_devices was never set"

 drivers/hid/hid-logitech-dj.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)


Thanks,

-- 
Jiri Kosina
SUSE Labs
