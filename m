Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754912AbaGBV4C (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 17:56:02 -0400
Received: from mail-wg0-f51.google.com ([74.125.82.51]:57114 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752654AbaGBVz7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 17:55:59 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Jingoo Han <jg1.han@samsung.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Rob Clark <robdclark@gmail.com>, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] video: fbdev: sh_mipi_dsi.c:  Cleaning up Boolean used in bitwise operation  
Date: Wed,  2 Jul 2014 23:57:11 +0200
Message-Id: <1404338232-6708-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Boolean variable is used in bitwise operation.
I personally find that this was pretty ugly, but think a solution like this yet is more correct.

This was found using a static code analysis program called cppcheck

Rickard Strandqvist (1):
  video: fbdev: sh_mipi_dsi.c:  Cleaning up Boolean used in bitwise operation

 drivers/video/fbdev/sh_mipi_dsi.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

-- 
1.7.10.4

