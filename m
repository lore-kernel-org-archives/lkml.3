Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752436AbaIADhq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2014 23:37:46 -0400
Received: from mail-ig0-f178.google.com ([209.85.213.178]:61233 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751893AbaIADhp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2014 23:37:45 -0400
From: Chase Southwood <chase.southwood@gmail.com>
To: gregkh@linuxfoundation.org
Cc: abbotti@mev.co.uk, hsweeten@visionengravers.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Chase Southwood <chase.southwood@gmail.com>
Subject: [PATCH 0/4] staging: comedi: hwdrv_apci1500: coding style cleanups
Date: Sun, 31 Aug 2014 22:37:38 -0500
Message-Id: <cover.1409542016.git.chase.southwood@gmail.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset begins by removing unneeded braces and commented out lines
of code, and then tidies whitespace issues that are revealed after the
braces/dead code is removed.

Chase Southwood (4):
  staging: comedi: hwdrv_apci1500: remove unneeded braces
  staging: comedi: hwdrv_apci1500: remove commented out code
  staging: comedi: hwdrv_apci1500: clean some whitespace style issues
  staging: comedi: hwdrv_apci1500: miscellaneous cleanup

 .../comedi/drivers/addi-data/hwdrv_apci1500.c      | 349 +++++++++------------
 1 file changed, 149 insertions(+), 200 deletions(-)

-- 
2.1.0

