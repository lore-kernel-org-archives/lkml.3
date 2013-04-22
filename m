Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755409Ab3DVUpX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 16:45:23 -0400
Received: from ven69-h01-31-33-9-98.dsl.sta.abo.bbox.fr ([31.33.9.98]:46595
	"EHLO laptop-kevin.kbaradon.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755375Ab3DVUpT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 16:45:19 -0400
From: Kevin Baradon <kevin.baradon@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Kevin Baradon <kevin.baradon@gmail.com>
Subject: [PATCH 0/4] Revert buggy patch and fix other issues with imon driver
Date: Mon, 22 Apr 2013 22:09:42 +0200
Message-Id: <1366661386-6720-1-git-send-email-kevin.baradon@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Following patchset fixes several issues with imon driver and reverts one
(previously applied) buggy patch.

Mauro, could you please apply this on top of your tree?

Best regards,


Kevin Baradon (4):
  Revert "media/rc/imon.c: make send_packet() delay larger for 15c2:0036"
  media/rc/imon.c: make send_packet() delay larger for 15c2:0036 [v2]
  media/rc/imon.c: do not try to register 2nd intf if 1st intf failed
  media/rc/imon.c: kill urb when send_packet() is interrupted

 drivers/media/rc/imon.c |   26 ++++++++++++++++++--------
 1 file changed, 18 insertions(+), 8 deletions(-)

--
1.7.10.4

