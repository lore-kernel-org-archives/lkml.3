Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758855Ab3HMQlD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 12:41:03 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:41495 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757432Ab3HMQlA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 12:41:00 -0400
From: Zubair Lutfullah <zubair.lutfullah@gmail.com>
To: sameo@linux.intel.com, lee.jones@linaro.org
Cc: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org
Subject: [PATCH] mfd: ti_am335x_tscadc: fix reg_cache in clr function
Date: Tue, 13 Aug 2013 17:40:55 +0100
Message-Id: <1376412056-20736-1-git-send-email-zubair.lutfullah@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed reg_cache in the set function. But missed the clr function
in the previous patch. This updates the clr function as well.

This applies after the previous fix I sent that Lee has accepted.
mfd-next hasn't been updated yet.


Zubair Lutfullah (1):
  mfd: ti_am335x_tscadc: Update reg_cache variable in clr function

 drivers/mfd/ti_am335x_tscadc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

-- 
1.7.9.5

