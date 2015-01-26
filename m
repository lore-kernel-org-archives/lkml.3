Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756950AbbAZXLb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 18:11:31 -0500
Received: from mx1.scotdoyle.com ([23.226.141.211]:32808 "EHLO
	mx1.scotdoyle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754291AbbAZXL3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 18:11:29 -0500
Date: Mon, 26 Jan 2015 23:09:41 +0000 (UTC)
From: Scot Doyle <lkml14@scotdoyle.com>
To: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>
cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        Richard Weinberger <richard.weinberger@gmail.com>,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v4 0/2] fbcon: user-defined cursor blink interval
Message-ID: <alpine.DEB.2.11.1501262305150.2783@localhost.localdomain>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since users prefer different fbcon cursor blink intervals, allow the
interval to be set via sysfs. The current interval of 200 milliseconds
is retained as the default. Tested with intelfb.

v2:  Use kstrtos16() instead of kstrtoul() and min_t() as suggested by
     Geert Uytterhoeven
v3:  Add error messages as suggested by Tomi Valkeinen
v4:  Add rationale into patch descriptions as suggested by
     Richard Weinberger

Scot Doyle (2):
  fbcon: store cursor blink interval in fbcon_ops
  fbcon: expose cursor blink interval via sysfs

 drivers/video/console/fbcon.c | 84 +++++++++++++++++++++++++++++++++++++++++--
 drivers/video/console/fbcon.h |  1 +
 2 files changed, 83 insertions(+), 2 deletions(-)

-- 
2.1.4

