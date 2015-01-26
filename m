Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756711AbbAZUjr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 15:39:47 -0500
Received: from mx1.scotdoyle.com ([23.226.141.211]:40149 "EHLO
	mx1.scotdoyle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753120AbbAZUjp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 15:39:45 -0500
Date: Mon, 26 Jan 2015 20:37:46 +0000 (UTC)
From: Scot Doyle <lkml14@scotdoyle.com>
To: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>
cc: Geert Uytterhoeven <geert@linux-m68k.org>, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 0/2] fbcon: user-defined cursor blink interval
Message-ID: <alpine.DEB.2.11.1501262034380.1945@localhost.localdomain>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow users to set fbcon's cursor blink interval. The current interval
of 200 milliseconds is retained as the default. Tested with intelfb.

v2:  Use kstrtos16() instead of kstrtoul() and min_t() as suggested by
     Geert Uytterhoeven
v3:  Add error messages as suggested by Tomi Valkeinen


Scot Doyle (2):
  fbcon: store cursor blink interval in fbcon_ops
  fbcon: expose cursor blink interval via sysfs

 drivers/video/console/fbcon.c | 84 +++++++++++++++++++++++++++++++++++++++++--
 drivers/video/console/fbcon.h |  1 +
 2 files changed, 83 insertions(+), 2 deletions(-)

-- 
2.1.4

