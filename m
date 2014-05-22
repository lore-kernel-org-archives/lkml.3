Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754330AbaEVJT5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 05:19:57 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:34739 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754306AbaEVJTy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 05:19:54 -0400
From: Keerthy <j-keerthy@ti.com>
To: <linux-omap@vger.kernel.org>
CC: <lgirdwood@gmail.com>, <broonie@kernel.org>,
        <linux-kernel@vger.kernel.org>, <sameo@linux.intel.com>,
        <lee.jones@linaro.org>, Keerthy <j-keerthy@ti.com>
Subject: [PATCH 0/2] regulator: palmas: Reemove open coded functions with helper functions
Date: Thu, 22 May 2014 14:48:28 +0530
Message-ID: <1400750310-20925-1-git-send-email-j-keerthy@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch series makes use of the helper functions and remove open coded
functions. The patch set also formats the palmas header file. Converts all
the offset values to hexadecimal. 

Boot Tested on omap5-uevm board.

Keerthy (2):
  regulator: palmas: Make use of helper functions and remove open coded
    functions
  mfd: palmas: Format the header file

 drivers/regulator/palmas-regulator.c |  158 +--
 include/linux/mfd/palmas.h           | 2166 +++++++++++++++++-----------------
 2 files changed, 1109 insertions(+), 1215 deletions(-)

-- 
1.7.9.5

