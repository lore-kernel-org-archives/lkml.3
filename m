Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758806Ab3K1E2i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 23:28:38 -0500
Received: from mail-ie0-f173.google.com ([209.85.223.173]:65320 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757791Ab3K1E2g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 23:28:36 -0500
From: Thomas Behan <thomas.behan@gmail.com>
To: linux-spi@vger.kernel.org
Cc: broonie@linaro.org, linux-kernel@vger.kernel.org,
        Thomas Behan <thomas.behan@gmail.com>
Subject: [PATCH 0/4] spi: omap-100k: Style Fixes
Date: Wed, 27 Nov 2013 23:27:20 -0500
Message-Id: <1385612844-22482-1-git-send-email-thomas.behan@gmail.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

First time contributer here submitting some style fixes. 

I watched Greg Kroah-Hartman's youtube video about getting started with
submitting patches and thought I would give it a try. I fixed up some errors
and warnings that checkpatch.pl was giving. All patches are based off of
linux-next.

Any feedback is much appreciated.

Thomas Behan (4):
  spi: omap-100k: Fixed spacing on while loops
  spi: omap-100k: Fixed spacing on -= operators
  spi: omap-100k: Fixed spacing on commas
  spi: omap-100k: Fixed style of sizeof operators

 drivers/spi/spi-omap-100k.c | 30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

-- 
1.8.1.2

