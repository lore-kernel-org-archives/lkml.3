Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752674AbaLCXQw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 18:16:52 -0500
Received: from mail-wg0-f51.google.com ([74.125.82.51]:52077 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750840AbaLCXQv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 18:16:51 -0500
From: Gabriele Mazzotta <gabriele.mzt@gmail.com>
To: mjg59@srcf.ucam.org, dvhart@infradead.org
Cc: pavel@ucw.cz, pali.rohar@gmail.com, platform-driver-x86@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Gabriele Mazzotta <gabriele.mzt@gmail.com>
Subject: [PATCH 0/3] dell-wmi: Don't send unneeded keypresses
Date: Thu,  4 Dec 2014 00:16:20 +0100
Message-Id: <1417648583-9336-1-git-send-email-gabriele.mzt@gmail.com>
X-Mailer: git-send-email 2.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently dell-wmi reports keypresses for WMI events that are
notifications of changes performed by the BIOS.
This patch series make sure that no keypresses are sent for those
events so that nothing is done from userspace. 

Gabriele Mazzotta (3):
  dell-wmi: Use appropriate keycode for radio state changes
  dell-wmi: Don't report keypresses for radio state changes
  dell-wmi: Don't report keypresses on keybord illumination change

 drivers/platform/x86/dell-wmi.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

-- 
2.1.3

