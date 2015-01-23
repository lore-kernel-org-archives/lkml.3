Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753445AbbAWTL7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 14:11:59 -0500
Received: from mail-pa0-f51.google.com ([209.85.220.51]:40190 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750890AbbAWTL5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 14:11:57 -0500
From: jitendra kumar khasdev <jkhasdev@gmail.com>
To: abbotti@mev.co.uk, hsweeten@visionengravers.com,
        gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        jitendra kumar khasdev <jkhasdev@gmail.com>
Subject: [PATCH v1 0/2] line over 80 character warnings.
Date: Sat, 24 Jan 2015 00:41:18 +0530
Message-Id: <1422040280-20213-1-git-send-email-jkhasdev@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In these two files jr3_pci.c, jr3_pci.h, 80 character warnings are reduced.

jitendra kumar khasdev (2):
  Staging: comedi: fix line over 80 characters warning
  Staging: comedi: fix line over 80 characters warning

 drivers/staging/comedi/drivers/jr3_pci.c | 3 ++-
 drivers/staging/comedi/drivers/jr3_pci.h | 5 +++--
 2 files changed, 5 insertions(+), 3 deletions(-)

-- 
1.9.1

