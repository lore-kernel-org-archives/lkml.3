Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753781AbbAXBMf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 20:12:35 -0500
Received: from mx1.scotdoyle.com ([23.226.141.211]:37396 "EHLO
	mx1.scotdoyle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751581AbbAXBMd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 20:12:33 -0500
Date: Sat, 24 Jan 2015 01:10:36 +0000 (UTC)
From: Scot Doyle <lkml14@scotdoyle.com>
To: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>
cc: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RFC PATCH 0/2] fbcon: user-defined cursor blink interval
Message-ID: <alpine.DEB.2.11.1501240109060.3489@localhost.localdomain>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow users to set fbcon's cursor blink interval. The current interval
of 200 milliseconds is retained as the default.

Tested with intelfb.

Scot Doyle (2):
  fbcon: store cursor blink interval in fbcon_ops
  fbcon: expose cursor blink interval via sysfs

 drivers/video/console/fbcon.c | 80 +++++++++++++++++++++++++++++++++++++++++--
 drivers/video/console/fbcon.h |  1 +
 2 files changed, 79 insertions(+), 2 deletions(-)

-- 
2.1.4

