Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752095AbaGaFb0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 01:31:26 -0400
Received: from relay1.mentorg.com ([192.94.38.131]:64412 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751362AbaGaFbZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 01:31:25 -0400
From: Sanjeev Sharma <sanjeev_sharma@mentor.com>
To: <gregkh@linuxfoundation.org>
CC: <oort10@gmail.com>, <devel@driverdev.osuosl.org>,
        <linux-kernel@vger.kernel.org>,
        Sanjeev Sharma <sanjeev_sharma@mentor.com>
Subject: [PATCH v2 0/3] Fixed commenting style problem 
Date: Thu, 31 Jul 2014 11:13:28 +0530
Message-ID: <1406785411-12538-1-git-send-email-sanjeev_sharma@mentor.com>
X-Mailer: git-send-email 1.7.11.7
MIME-Version: 1.0
Content-Type: text/plain
X-OriginalArrivalTime: 31 Jul 2014 05:31:23.0497 (UTC) FILETIME=[AA98DD90:01CFAC80]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

AddedSigned-off-by: line that was missing.

Sanjeev Sharma (3):
  staging:r8180: coding style: Fixed commenting style
  staging:r8180: coding style: Fixed too long lines
  staging:r8190: coding style: Fixed checkpatch reported Error

 drivers/staging/rtl8192u/r8180_93cx6.c   |  15 +--
 drivers/staging/rtl8192u/r8180_93cx6.h   |  11 +-
 drivers/staging/rtl8192u/r8190_rtl8256.c | 169 +++++++++++++++----------------
 3 files changed, 95 insertions(+), 100 deletions(-)

-- 
1.7.11.7

