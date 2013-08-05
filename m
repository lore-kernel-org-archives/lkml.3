Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754135Ab3HERk0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 13:40:26 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:59012 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752127Ab3HERkY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 13:40:24 -0400
From: Rupesh Gujare <rupesh.gujare@atmel.com>
To: <devel@linuxdriverproject.org>
CC: <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <gregkh@linuxfoundation.org>
Subject: [PATCH 0/4] staging: ozwpan: Fix crash issues.
Date: Mon, 5 Aug 2013 18:40:11 +0100
Message-ID: <1375724415-10801-1-git-send-email-rupesh.gujare@atmel.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series fixes crash issues observed,
& fix a bug in hub status code.

Rupesh Gujare (4):
  staging: ozwpan: Fixes crash due to invalid port aceess.
  staging: ozwpan: Increment port number for new device.
  staging: ozwpan: Reset port configuration number.
  staging: ozwpan: Return correct hub status.

 drivers/staging/ozwpan/ozhcd.c |   37 ++++++++++++++++++++++++++++---------
 1 file changed, 28 insertions(+), 9 deletions(-)

-- 
1.7.9.5

