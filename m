Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754160AbbAZNZm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 08:25:42 -0500
Received: from smtp73.iad3a.emailsrvr.com ([173.203.187.73]:37454 "EHLO
	smtp73.iad3a.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750830AbbAZNZj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 08:25:39 -0500
X-Sender-Id: abbotti@mev.co.uk
From: Ian Abbott <abbotti@mev.co.uk>
To: <driverdev-devel@linuxdriverproject.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/5] staging: comedi: 8255.[ch]: reformat comments
Date: Mon, 26 Jan 2015 13:25:20 +0000
Message-Id: <1422278725-17740-1-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reformat comments to usual style and add kerneldoc to exported
functions.

1) staging: comedi: 8255.c: reformat copyright comment
2) staging: comedi: 8255.c: reformat comedi driver comment
3) staging: comedi: 8255.c: document subdev_8255_init() and _mm_init()
4) staging: comedi: 8255.c: reformat remaining block comments
5) staging: comedi: 8255.h: reformat copyright comment

 drivers/staging/comedi/drivers/8255.c | 174 ++++++++++++++++++++--------------
 drivers/staging/comedi/drivers/8255.h |  32 +++----
 2 files changed, 117 insertions(+), 89 deletions(-)
