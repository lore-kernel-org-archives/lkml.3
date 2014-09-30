Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754291AbaI3GKH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 02:10:07 -0400
Received: from mail-ig0-f171.google.com ([209.85.213.171]:38602 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751365AbaI3GKF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 02:10:05 -0400
Date: Tue, 30 Sep 2014 01:07:48 -0500
From: Eric Rost <eric.rost@mybabylon.net>
To: gregkh@linuxfoundation.org, jason@lakedaemon.net, jake@lwn.net,
        antonysaraev@gmail.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/4] staging: skein: Fixes whitespace warnings
Message-ID: <cover.1412056799.git.eric.rost@mybabylon.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset reorganizes skein_block.c to move macro definitions out of
functions, fixes whitspace issues, and removes the need for the #if'd
for loops.

Eric Rost (4):
  drivers: staging: skein: Whitespace cleanup
  drivers: staging: skein: Additional Whitespace Issues
  drivers: staging: skein: In progress
  drivers: staging: skein: File Reorg

 drivers/staging/skein/skein_block.c |  933 +++++++++++++++++++----------------
 1 file changed, 500 insertions(+), 433 deletions(-)

-- 
1.7.10.4

