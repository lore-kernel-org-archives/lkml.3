Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753321AbaEZPYl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 11:24:41 -0400
Received: from isis.lip6.fr ([132.227.60.2]:56632 "EHLO isis.lip6.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753303AbaEZPYj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 11:24:39 -0400
X-pt: isis.lip6.fr
From: Benoit Taine <benoit.taine@lip6.fr>
To: linux-media@vger.kernel.org
Cc: benoit.taine@lip6.fr, dri-devel@lists.freedesktop.org,
        devel@driverdev.osuosl.org, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, wcn36xx@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        usb-storage@lists.one-eyed-alien.net, linux-scsi@vger.kernel.org,
        DL-MPTFusionLinux@lsi.com, linux-input@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH 0/18] Use kmemdup instead of kmalloc + memcpy
Date: Mon, 26 May 2014 17:21:09 +0200
Message-Id: <1401117687-28911-1-git-send-email-benoit.taine@lip6.fr>
X-Mailer: git-send-email 1.9.3
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.4.3 (isis.lip6.fr [132.227.60.2]); Mon, 26 May 2014 17:20:42 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches enhance kernel style usage, and allows smaller code while
preventing accidental code edits to produce overflows.

The semantic patch at scripts/coccinelle/api/memdup.cocci was used to
detect and edit this situation.
