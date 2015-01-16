Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756166AbbAPNvM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 08:51:12 -0500
Received: from mx1.redhat.com ([209.132.183.28]:57227 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751858AbbAPNvK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 08:51:10 -0500
From: Rafael Aquini <aquini@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, jweiner@redhat.com, dave.hansen@linux.intel.com,
        rientjes@google.com, linux-mm@kvack.org
Subject: [PATCH 0/2] Tiny adjustments to /proc/pid/numa_maps interface and documentation
Date: Fri, 16 Jan 2015 08:50:49 -0500
Message-Id: <cover.1421415776.git.aquini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This small patchset aims to add missing documentation to the /proc/pid/numa_maps interface
as well as perform a small adjustment on the report output, as suggested by
Andrew Morton, in the following discussion thread:
 * https://lkml.org/lkml/2015/1/5/769 

Rafael Aquini (2):
  documentation: proc: add /proc/pid/numa_maps interface explanation
    snippet
  fs: proc: task_mmu: bump kernelpagesize_kB to EOL in
    /proc/pid/numa_maps

 Documentation/filesystems/proc.txt | 33 +++++++++++++++++++++++++++++++++
 fs/proc/task_mmu.c                 |  4 ++--
 2 files changed, 35 insertions(+), 2 deletions(-)

-- 
1.9.3

