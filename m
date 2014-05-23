Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752034AbaEWEiu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 00:38:50 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:38939 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751013AbaEWEit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 00:38:49 -0400
From: David Matlack <matlackdavid@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org, liodot@gmail.com,
        charrer@alacritech.com, David Matlack <matlackdavid@gmail.com>
Subject: [PATCH 0/2] fix two bugs in slic_card_init
Date: Thu, 22 May 2014 21:38:43 -0700
Message-Id: <1400819925-19390-1-git-send-email-matlackdavid@gmail.com>
X-Mailer: git-send-email 1.9.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset fixes two bugs in slic_card_init(). They are grouped in
a series because the second patch depends on the first (for a merge 
without conflicts). In content, they are completely separate changes.
They just touch a few of the same lines.

David Matlack (2):
  staging: slicoss: fix dma memory leak
  staging: slicoss: handle errors from slic_config_get

 drivers/staging/slicoss/slicoss.c | 25 ++++++++++++++++---------
 1 file changed, 16 insertions(+), 9 deletions(-)

-- 
1.9.2

