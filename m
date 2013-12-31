Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932439Ab3LaCHJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Dec 2013 21:07:09 -0500
Received: from mail-oa0-f42.google.com ([209.85.219.42]:41873 "EHLO
	mail-oa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752516Ab3LaCHG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Dec 2013 21:07:06 -0500
From: "Felipe F. Tonello" <eu@felipetonello.com>
To: linux-input@vger.kernel.org
Cc: "Felipe F. Tonello" <eu@felipetonello.com>, linux-kernel@vger.kernel.org,
        Henrik Rydberg <rydberg@euromail.se>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 0/2] input: mt: Add helper function to send end events
Date: Mon, 30 Dec 2013 18:06:39 -0800
Message-Id: <1388455601-17033-1-git-send-email-eu@felipetonello.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Felipe F. Tonello" <eu@felipetonello.com>

Adds a helper function to send end touch events for active tracking ids.
And also implements it in egalax driver.

Felipe F. Tonello (2):
  input: mt: Add helper function to send end events
  input: egalax: report end state in suspend callback

 drivers/input/input-mt.c              | 33 +++++++++++++++++++++++++++++++++
 drivers/input/touchscreen/egalax_ts.c |  5 +++++
 include/linux/input/mt.h              |  2 ++
 3 files changed, 40 insertions(+)

-- 
1.8.3.1

