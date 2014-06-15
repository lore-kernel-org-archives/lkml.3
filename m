Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752274AbaFOVvS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2014 17:51:18 -0400
Received: from mail-we0-f180.google.com ([74.125.82.180]:44005 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752139AbaFOVvO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2014 17:51:14 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Jingoo Han <jg1.han@samsung.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Rob Clark <robdclark@gmail.com>, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] video: fbdev: sis: init301.c:  Cleaning up useless if statement  
Date: Sun, 15 Jun 2014 23:52:09 +0200
Message-Id: <1402869130-4962-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The same code regardless of the outcome of the if statement. This may of
course be a miss and there should be a difference in the code.
And sets a variable that is missed, a probable cut and paste mistake.

This was partly found using a static code analysis program called cppcheck.

Rickard Strandqvist (1):
  video: fbdev: sis: init301.c:  Cleaning up useless if statement

 drivers/video/fbdev/sis/init301.c |   19 +++++--------------
 1 file changed, 5 insertions(+), 14 deletions(-)

-- 
1.7.10.4

