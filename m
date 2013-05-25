Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757501Ab3EYRkC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 May 2013 13:40:02 -0400
Received: from mail-pb0-f50.google.com ([209.85.160.50]:36287 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757430Ab3EYRj7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 May 2013 13:39:59 -0400
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
To: Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        LMML <linux-media@vger.kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH v2 0/4] media: i2c: ths7303 cleanup
Date: Sat, 25 May 2013 23:09:32 +0530
Message-Id: <1369503576-22271-1-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lad, Prabhakar <prabhakar.csengg@gmail.com>

Trivial cleanup of the driver.

Changes for v2:
1: Dropped the asynchronous probing and, OF
   support patches will be handling them independently because of dependencies.
2: Arranged the patches logically so that git bisect 
   succeeds.

Lad, Prabhakar (4):
  ARM: davinci: dm365 evm: remove init_enable from ths7303 pdata
  media: i2c: ths7303: remove init_enable option from pdata
  media: i2c: ths7303: remove unnecessary function ths7303_setup()
  media: i2c: ths7303: make the pdata as a constant pointer

 arch/arm/mach-davinci/board-dm365-evm.c |    1 -
 drivers/media/i2c/ths7303.c             |   48 ++++++++-----------------------
 include/media/ths7303.h                 |    2 -
 3 files changed, 12 insertions(+), 39 deletions(-)

