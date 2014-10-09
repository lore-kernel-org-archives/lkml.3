Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757337AbaJINyX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 09:54:23 -0400
Received: from mail-ig0-f169.google.com ([209.85.213.169]:39575 "EHLO
	mail-ig0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756031AbaJINyK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 09:54:10 -0400
From: Jia He <hejianet@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Jia He <hejianet@gmail.com>
Subject: [PATCH 0/2] staging: rtl8188eu: Fix a series of coding style problems
Date: Thu,  9 Oct 2014 21:53:51 +0800
Message-Id: <1412862833-19015-1-git-send-email-hejianet@gmail.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1412845387-17668-1-git-send-email-hejianet@gmail.com>
References: <1412845387-17668-1-git-send-email-hejianet@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes all coding style error problems at rtl8188eu which
makes checkpatch.pl unhappy

Jia He (2):
  staging: rtl8188eu: Fix coding style space missing problems
  staging: rtl8188eu: Fix coding style not using tab problem

 drivers/staging/rtl8188eu/hal/bb_cfg.c | 4 ++--
 drivers/staging/rtl8188eu/hal/fw.c     | 4 ++--
 drivers/staging/rtl8188eu/hal/phy.c    | 2 +-
 drivers/staging/rtl8188eu/hal/rf.c     | 4 ++--
 drivers/staging/rtl8188eu/hal/rf_cfg.c | 4 ++--
 5 files changed, 9 insertions(+), 9 deletions(-)

-- 
1.9.3

