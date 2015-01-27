Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759770AbbA0UaY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 15:30:24 -0500
Received: from mail-we0-f169.google.com ([74.125.82.169]:45025 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755238AbbA0UaX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 15:30:23 -0500
Date: Tue, 27 Jan 2015 22:30:15 +0200
From: Heba Aamer <heba93aamer@gmail.com>
To: devel@driverdev.osuosl.org
Cc: gregkh@linuxfoundation.org, notro@tronnes.org,
        thomas.petazzoni@free-electrons.com, linux-kernel@vger.kernel.org
Subject: [PATCH 0/6] Fix fbtft/fb_pcd8544.c coding style errors
Message-ID: <cover.1422296762.git.heba93aamer@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set fixes most of the checkpatch.pl coding
style errors found in drivers/staging/fbtft/fb_pcd8544.c

Heba Aamer (6):
  staging: fbtft: fix space required after that ';'
  staging: fbtft: fix spaces required around that '='
  staging: fbtft: fix spaces required around that '<'
  staging: fbtft: fix Macros with complex values should be enclosed in
    parentheses
  staging: fbtft: fix do not initialise statics to 0 or NULL
  staging: fbtft: fix trailing whitespace

 drivers/staging/fbtft/fb_pcd8544.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

-- 
1.7.9.5

