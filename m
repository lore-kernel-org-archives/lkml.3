Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755974Ab3KVRau (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 12:30:50 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:42863 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755904Ab3KVRat (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 12:30:49 -0500
From: Olav Haugan <ohaugan@codeaurora.org>
To: gregkh@linuxfoundation.org
Cc: ngupta@vflare.org, sjenning@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org, minchan@kernel.org,
        linux-arm-msm@vger.kernel.org, Olav Haugan <ohaugan@codeaurora.org>
Subject: [PATCH v3 0/1] staging: zsmalloc: Ensure handle is never 0 on success
Date: Fri, 22 Nov 2013 09:30:40 -0800
Message-Id: <1385141441-16446-1-git-send-email-ohaugan@codeaurora.org>
X-Mailer: git-send-email 1.8.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

v3:
Updated commit text with info about affected SoCs.

v2:
Added comments to code.
Updated commit text.

Olav Haugan (1):
  staging: zsmalloc: Ensure handle is never 0 on success

 drivers/staging/zsmalloc/zsmalloc-main.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

-- 
The Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

