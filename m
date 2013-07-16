Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933532Ab3GPRV1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 13:21:27 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:34274 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933488Ab3GPRVZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 13:21:25 -0400
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: "Hans J. Koch" <hjk@hansjkoch.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, kernel@pengutronix.de
Subject: [PATCH 0/2] Resend of two uio patches
Date: Tue, 16 Jul 2013 19:21:02 +0200
Message-Id: <1373995264-31448-1-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.8.3.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

these two patches were already sent back in April but fell through the
cracks. They are not really related, but send in a series because they
fail to apply in reverse order.

Patch 1 is useful for debugging with gdb, patch 2 is a cleanup. Note
that patch 2 is only compile-tested because I don't have an uio driver
that uses a non-physical map.                                                                                                                         
Best regards
Uwe

Uwe Kleine-König (2):
  uio: provide vm access to UIO_MEM_PHYS maps
  uio: drop unused vma_count member in uio_device struct

 drivers/uio/uio.c | 38 ++++++++++++++------------------------
 1 file changed, 14 insertions(+), 24 deletions(-)

-- 
1.8.3.2

