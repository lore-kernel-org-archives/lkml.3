Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755542AbaDVKPG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 06:15:06 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:37597 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752662AbaDVKPA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 06:15:00 -0400
X-IronPort-AV: E=Sophos;i="4.97,900,1389715200"; 
   d="scan'208";a="29566545"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: <linux-kernel@vger.kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 0/4] idr: idr cleanups
Date: Tue, 22 Apr 2014 18:16:17 +0800
Message-ID: <1398161781-12105-1-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.167.226.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

patch1 is the new version of previous pathset.(it is dropped by previous
	patchset, this one is new)

patch2/3 save a lot memory

Lai Jiangshan (4):
  idr: proper invalid argument handling
  idr: reduce the number of MAX_IDR_FREE
  ida: in-place ida allocation
  idr: reorder the fields

 include/linux/idr.h |   28 ++++--------
 lib/idr.c           |  119 ++++++++++++++++++---------------------------------
 2 files changed, 51 insertions(+), 96 deletions(-)

-- 
1.7.4.4

