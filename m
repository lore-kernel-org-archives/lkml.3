Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751520AbaIJGDj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 02:03:39 -0400
Received: from mail-ig0-f177.google.com ([209.85.213.177]:37024 "EHLO
	mail-ig0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750978AbaIJGDi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 02:03:38 -0400
From: Chase Southwood <chase.southwood@gmail.com>
To: gregkh@linuxfoundation.org
Cc: abbotti@mev.co.uk, hsweeten@visionengravers.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Chase Southwood <chase.southwood@gmail.com>
Subject: [PATCH 0/4] staging: comedi: hwdrv_apci1320: style cleanups
Date: Wed, 10 Sep 2014 01:03:25 -0500
Message-Id: <cover.1409983606.git.chase.southwood@gmail.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset begins by cleaning up the mess of the comments in
this driver, then follows that with three very small and trivial
checkpatch warning fixes.

Chase Southwood (4):
  staging: comedi: hwdrv_apci3120: clean up comments
  staging: comedi: hwdrv_apci3120: add a blank line after declarations
  staging: comedi: hwdrv_apci3120: else is not useful after return
  staging: comedi: hwdrv_apci3120: remove void function return statement

 .../comedi/drivers/addi-data/hwdrv_apci3120.c      | 369 +++++++--------------
 1 file changed, 119 insertions(+), 250 deletions(-)

-- 
2.1.0

