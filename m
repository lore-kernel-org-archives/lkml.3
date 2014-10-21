Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933804AbaJUW4o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 18:56:44 -0400
Received: from mail-ig0-f173.google.com ([209.85.213.173]:43235 "EHLO
	mail-ig0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933486AbaJUW4m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 18:56:42 -0400
From: Brian Vandre <bvandre@gmail.com>
To: gregkh@linuxfoundation.org, jic23@kernel.org,
        alexandre.belloni@free-electrons.com, linux-iio@vger.kernel.org,
        marex@denx.de
Cc: Brian Vandre <bvandre@gmail.com>, linux-kernel@vger.kernel.org
Subject: [PATCH v2] Staging: iio: adc: Checkpatch.pl warning cleanups
Date: Tue, 21 Oct 2014 17:56:46 -0500
Message-Id: <cover.1413931615.git.bvandre@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <cover.1413858979.git.bvandre@gmail.com>
References: <cover.1413858979.git.bvandre@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch-set fixes 2 checkpatch.pl warnings
dealing with lines over 80 characters.

Changes from v1:
-squashed 2 patches into 1 as suggested by Alexandre Belloni


Brian Vandre (1):
  Staging: iio: adc: fix line over 80 characters

 drivers/staging/iio/adc/mxs-lradc.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

-- 
1.9.1

