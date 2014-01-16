Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752678AbaAPN1f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 08:27:35 -0500
Received: from e06smtp10.uk.ibm.com ([195.75.94.106]:49188 "EHLO
	e06smtp10.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752626AbaAPN1c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 08:27:32 -0500
From: Philipp Hachtmann <phacht@linux.vnet.ibm.com>
To: akpm@linux-foundation.org
Cc: tangchen@cn.fujitsu.com, zhangyanfei@cn.fujitsu.com,
        phacht@linux.vnet.ibm.com, yinghai@kernel.org,
        grygorii.strashko@ti.com, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, schwidefsky@de.ibm.com
Subject: [PATCH V4 0/2] mm/memblock: Excluded memory
Date: Thu, 16 Jan 2014 14:27:05 +0100
Message-Id: <1389878827-7827-1-git-send-email-phacht@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.4.5
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14011613-4966-0000-0000-0000081666CB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here is a new version of the memblock.nomap patch.

This time without the first patch (that has already been taken by akpm).

The second patch is now split into the functional part (Add support...)
and the cleanup/refactoring part. This has been done for clarity as
announced before.

Philipp Hachtmann (2):
  mm/memblock: Add support for excluded memory areas
  mm/memblock: Cleanup and refactoring after addition of nomap

 include/linux/memblock.h |  57 +++++++++---
 mm/Kconfig               |   3 +
 mm/memblock.c            | 233 +++++++++++++++++++++++++++++++++++------------
 mm/nobootmem.c           |   9 ++
 4 files changed, 231 insertions(+), 71 deletions(-)

-- 
1.8.4.5

