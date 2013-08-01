Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756933Ab3HARkZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 13:40:25 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:47371 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755584Ab3HARkX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 13:40:23 -0400
From: Rupesh Gujare <rupesh.gujare@atmel.com>
To: <devel@linuxdriverproject.org>
CC: <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <gregkh@linuxfoundation.org>
Subject: [PATCH 0/6] staging: ozwpan: Use Kernel API & Bug fixes
Date: Thu, 1 Aug 2013 18:39:59 +0100
Message-ID: <1375378806-17948-1-git-send-email-rupesh.gujare@atmel.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series removes duplicate code, & replaces it
with kernel library functions, and few bug fixes.

Rupesh Gujare (6):
  staging: ozwpan: Use kernel list function for managing interface
    list.
  staging: ozwpan: Mark string as const
  staging: ozwpan: Use kernel strncmp function.
  staging: ozwpan: Drop oldest ISOC frame instead of dropping latest.
  staging: ozwpan: Increase farewell report size.
  staging: ozwpan: Set farewell report length.

 drivers/staging/ozwpan/ozpd.c    |   13 +++++++++-
 drivers/staging/ozwpan/ozpd.h    |    2 +-
 drivers/staging/ozwpan/ozproto.c |   51 +++++++++++++-------------------------
 drivers/staging/ozwpan/ozproto.h |    4 +--
 4 files changed, 32 insertions(+), 38 deletions(-)

-- 
1.7.9.5

