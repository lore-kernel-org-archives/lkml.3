Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751653AbaI3G6z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 02:58:55 -0400
Received: from mail-ig0-f172.google.com ([209.85.213.172]:43177 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751056AbaI3G6x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 02:58:53 -0400
Date: Tue, 30 Sep 2014 01:56:39 -0500
From: Eric Rost <eric.rost@mybabylon.net>
To: gregkh@linuxfoundation.org, jason@lakedaemon.net, jake@lwn.net,
        antonysaraev@gmail.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 0/3] staging: skein: checkpatch.pl warnings
Message-ID: <cover.1412060010.git.eric.rost@mybabylon.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes the follwoing checkpatch.pl warnings:
WARNING: suspect code indent for conditional statements (16, 16)
+               for (r = 1; r < 2 * RCNT; r += 2 * SKEIN_UNROLL_512)
[...]
+               {

WARNING: suspect code indent for conditional statements (16, 16)
+               for (r = 1; r <= 2 * RCNT; r += 2 * SKEIN_UNROLL_1024)
[...]
+               {


Eric Rost (3):
  staging: skein: Whitespace cleanup
  drivers: staging: skein: In progress
  drivers: staging: skein: File Reorg

 drivers/staging/skein/skein_block.c |  933 +++++++++++++++++++----------------
 1 file changed, 500 insertions(+), 433 deletions(-)

-- 
1.7.10.4

