Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753739AbaFRROQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 13:14:16 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:33100 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753237AbaFRROO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 13:14:14 -0400
From: Joseph Salisbury <joseph.salisbury@canonical.com>
To: kamal.mostafa@canonical.com
Cc: perex@perex.cz, tiwai@suse.de, eldad@fogrefinery.com, clemens@ladisch.de,
        tim.gardner@canonical.com, stern@rowland.harvard.edu,
        linux@eikelenboom.it, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: [v3.13.y][SRU][PATCH 0/1] ALSA: usb-audio: Prevent printk ratelimiting from spamming kernel log while DEBUG not defined
Date: Wed, 18 Jun 2014 13:14:05 -0400
Message-Id: <cover.1400085278.git.joseph.salisbury@canonical.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

BugLink: http://bugs.launchpad.net/bugs/1319457

Hello,

Please consider including upstream commit b7a77235 in the next v3.13.y release.  It was included upstream as of v3.15-rc5.  It has been tested and confirmed to resolve http://bugs.launchpad.net/bugs/1319457 .

commit b7a7723513dc89f83d6df13206df55d4dc26e825
Author: Sander Eikelenboom <linux@eikelenboom.it>
Date:   Fri May 2 15:09:27 2014 +0200

    ALSA: usb-audio: Prevent printk ratelimiting from spamming kernel log while DEBUG not defined


This commit does not apply cleanly to v3.13, so I performed a backport, which is in email 1/1. 


Sander Eikelenboom (1):
  ALSA: usb-audio: Prevent printk ratelimiting from spamming kernel log
    while DEBUG not defined

 sound/usb/pcm.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

-- 
1.9.1

