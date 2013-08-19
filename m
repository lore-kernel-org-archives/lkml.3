Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751080Ab3HSQhL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 12:37:11 -0400
Received: from etezian.org ([198.101.225.253]:41451 "EHLO mail.etezian.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750818Ab3HSQhK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 12:37:10 -0400
From: Andi Shyti <andi@etezian.org>
To: josh.h.morris@us.ibm.com, pjk1939@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, andi@etezian.org
Subject: [PATCH v2 0/1] fix meamleak on rsxx/core.c
Date: Mon, 19 Aug 2013 18:36:35 +0200
Message-Id: <1376930196-21785-1-git-send-email-andi@etezian.org>
X-Mailer: git-send-email 1.8.4.rc2
In-Reply-To: <1376907631-13725-1-git-send-email-andi@etezian.org>
References: <1376907631-13725-1-git-send-email-andi@etezian.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

this version is a bit better since it fixes two memleak situations.

Andi

Andi Shyti (1):
  rsxx: core: fix memory leak

 drivers/block/rsxx/core.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

-- 
1.8.4.rc2

