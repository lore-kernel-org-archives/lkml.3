Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752009Ab3HUAv4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 20:51:56 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:63760 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751385Ab3HUAvx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 20:51:53 -0400
From: Libin <huawei.libin@huawei.com>
To: <tj@kernel.org>
CC: <linux-kernel@vger.kernel.org>, <wangyijing@huawei.com>,
        <guohanjun@huawei.com>
Subject: [PATCH v2 0/3] workqueue: Comment/Doc correction with no functional change
Date: Wed, 21 Aug 2013 08:50:38 +0800
Message-ID: <1377046241-18516-1-git-send-email-huawei.libin@huawei.com>
X-Mailer: git-send-email 1.8.1.msysgit.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.135.74.57]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set doesn't make any functional differences.

Libin (3):
  workqueue: Comment correction in file header
  workqueue: Fix manage_workers() RETURNS description
  workqueue: Correct/Drop references to gcwq in Documentation

 Documentation/workqueue.txt | 72 ++++++++++++++++++++++-----------------------
 kernel/workqueue.c          | 14 +++++----
 2 files changed, 45 insertions(+), 41 deletions(-)

-- 
1.8.2.1


