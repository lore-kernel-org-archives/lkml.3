Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754482AbaGBWHX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 18:07:23 -0400
Received: from mail-wi0-f174.google.com ([209.85.212.174]:37967 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752804AbaGBWHV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 18:07:21 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Jingoo Han <jg1.han@samsung.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Rob Clark <robdclark@gmail.com>, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] video: fbdev: sis: init301.c:  Cleaning up a potential division by zero  
Date: Thu,  3 Jul 2014 00:08:34 +0200
Message-Id: <1404338915-6946-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Guess these ifdef will always be set, but still feel that 1 is a better starting value other than 0 in this case.

This was found using a static code analysis program called cppcheck

Rickard Strandqvist (1):
  video: fbdev: sis: init301.c:  Cleaning up a potential division by zero

 drivers/video/fbdev/sis/init301.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

-- 
1.7.10.4

