Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751803AbaJADYQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 23:24:16 -0400
Received: from mail-ig0-f171.google.com ([209.85.213.171]:53593 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750833AbaJADYO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 23:24:14 -0400
Date: Tue, 30 Sep 2014 22:22:01 -0500
From: Eric Rost <eric.rost@mybabylon.net>
To: gregkh@linuxfoundation.org, jason@lakedaemon.net, jake@lwn.net,
        antonysaraev@gmail.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH v4 0/2] staging: skein: Fixes Conditional white space problems
Message-ID: <cover.1412133487.git.eric.rost@mybabylon.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset fixes the following checkpatch.pl Warnings in
skein_block.c:

WARNING: suspect code indent for conditional statements (16, 16)
+               for (r = 1; r < 2 * RCNT; r += 2 * SKEIN_UNROLL_512)
[...]
+               {

WARNING: suspect code indent for conditional statements (16, 16)
+               for (r = 1; r <= 2 * RCNT; r += 2 * SKEIN_UNROLL_1024)
[...]
+               {

It also removes macro definitions from inside functions and cleans up
whitespace issues.

Eric Rost (2):
  staging: skein: Whitespace cleanup
  staging: skein: File Reorg

 drivers/staging/skein/skein_block.c |  933 +++++++++++++++++++----------------
 1 file changed, 500 insertions(+), 433 deletions(-)

-- 
1.7.10.4

