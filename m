Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754445AbbATRi5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 12:38:57 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:26092 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751895AbbATRi4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 12:38:56 -0500
From: Sasha Levin <sasha.levin@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: iamjoonsoo.kim@lge.com, m.szyprowski@samsung.com,
        akpm@linux-foundation.org, lauraa@codeaurora.org,
        Sasha Levin <sasha.levin@oracle.com>
Subject: [PATCH 0/3] mm: cma: debugfs access to CMA
Date: Tue, 20 Jan 2015 12:38:30 -0500
Message-Id: <1421775513-4460-1-git-send-email-sasha.levin@oracle.com>
X-Mailer: git-send-email 2.1.0
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've noticed that there is no interfaces exposed by CMA which would let me
fuzz what's going on in there.

This small patch set exposes some information out to userspace, plus adds
the ability to trigger allocation and freeing from userspace.

Sasha Levin (3):
  mm: cma: debugfs interface
  mm: cma: allocation trigger
  mm: cma: release trigger

 mm/Kconfig     |    6 ++
 mm/Makefile    |    1 +
 mm/cma.c       |   19 ++----
 mm/cma.h       |   20 +++++++
 mm/cma_debug.c |  175 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 206 insertions(+), 15 deletions(-)
 create mode 100644 mm/cma.h
 create mode 100644 mm/cma_debug.c

-- 
1.7.10.4

