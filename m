Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754175AbaDRUXv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 16:23:51 -0400
Received: from mail-ee0-f41.google.com ([74.125.83.41]:59168 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752482AbaDRUXr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 16:23:47 -0400
From: Konrad Zapalowicz <bergo.torino@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Konrad M Zapalowicz <bergo.torino@gmail.com>
Subject: [PATCH 0/2] staging: rtl8188eu: fix checkpatch errors.
Date: Fri, 18 Apr 2014 22:23:05 +0200
Message-Id: <1397852587-8170-1-git-send-email-bergo.torino@gmail.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Konrad M Zapalowicz <bergo.torino@gmail.com>

This patch removes the following checkpatch errors:

rtl8188eu/core/rtw_p2p.c:
    - 1508: ERROR: code indent should use tabs where possible
    - 1509: ERROR: code indent should use tabs where possible
    - 1510: ERROR: code indent should use tabs where possible
rtl8188eu/core/rtw_recv.c
    - 1874: ERROR: code indent should use tabs where possible

Konrad M Zapalowicz (2):
  staging: rtl8188eu: fix spaces instead of tabs for rtw_p2p.c
  staging: rtl8188eu: fix spaces instead of tabs for rtw_recv.c

 drivers/staging/rtl8188eu/core/rtw_p2p.c  | 6 +++---
 drivers/staging/rtl8188eu/core/rtw_recv.c | 2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

-- 
1.8.1.2

