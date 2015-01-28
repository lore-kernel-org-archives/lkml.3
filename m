Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759431AbbA1U3K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 15:29:10 -0500
Received: from mail-wi0-f175.google.com ([209.85.212.175]:60451 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753000AbbA1U3F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:29:05 -0500
Date: Wed, 28 Jan 2015 13:16:45 +0200
From: Heba Aamer <heba93aamer@gmail.com>
To: devel@driverdev.osuosl.org
Cc: thomas.petazzoni@free-electrons.com, noralf@tronnes.org,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/5] Fix fbtft/fb_pcd8544.c coding style errors and warnings
Message-ID: <cover.1422443132.git.heba93aamer@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set fixes most of the checkpatch.pl coding style
errors and warnings found in drivers/staging/fbtft/fb_pcd8544.c

Regarding the spaces fixes the git diff -w showed no difference,
and the objdiff was empty.

Heba Aamer (5):
  staging: fbtft: fix Macros with complex values should be enclosed in
    parentheses
  staging: fbtft: fix do not initialise statics to 0 or NULL
  staging: fbtft: fix horizontal spaces errors
  staging: fbtft: fix trailing whitespace
  staging: fbtft: fix braces {} are not necessary for single statement
    blocks

 drivers/staging/fbtft/fb_pcd8544.c |   17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

-- 
1.7.9.5

