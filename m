Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751241AbaEQTXq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2014 15:23:46 -0400
Received: from mail-ee0-f42.google.com ([74.125.83.42]:38554 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751180AbaEQTXo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2014 15:23:44 -0400
From: Konrad Zapalowicz <bergo.torino@gmail.com>
To: gregkh@linuxfoundation.org
Cc: standby24x7@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        Konrad Zapalowicz <bergo.torino@gmail.com>
Subject: [PATCH 0/2] staging: rtl8821ae: fix sparse warnings in sw.c
Date: Sat, 17 May 2014 21:23:36 +0200
Message-Id: <1400354618-13471-1-git-send-email-bergo.torino@gmail.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set fixes sparse warnings in sw.c file of rtl8821ae driver.
In particular it deals with:
    1) double const definition
    2) missing 'static' for a few local symbols

Konrad Zapalowicz (2):
  staging: rtl8821ae: fix double const in sw.c
  staging: rtl8821ae: fix not declared symbols should be static in sw.c

 drivers/staging/rtl8821ae/rtl8821ae/sw.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

-- 
1.8.1.2

