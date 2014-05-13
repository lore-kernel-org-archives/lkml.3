Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933315AbaEMKKw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 06:10:52 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50664 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933231AbaEMKJe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 06:09:34 -0400
From: Takashi Iwai <tiwai@suse.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] minor console cleanup patches
Date: Tue, 13 May 2014 12:09:26 +0200
Message-Id: <1399975769-30526-1-git-send-email-tiwai@suse.de>
X-Mailer: git-send-email 1.9.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

here is a small series of cleanup patches for some annoyance I
stumbled during debugging the framebuffer issues:

 [PATCH 1/3] vgacon: Fix & cleanup refcounting
 [PATCH 2/3] console: Use explicit pointer type for vc_uni_pagedir*
 [PATCH 3/3] console: Remove superfluous readonly check

There should be no functional changes by this.


Takashi

