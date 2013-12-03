Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752363Ab3LCJnV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 04:43:21 -0500
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:7787 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751775Ab3LCJnS convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 04:43:18 -0500
From: Con Kolivas <kernel@kolivas.org>
To: linux-kernel@vger.kernel.org
Subject: [ANNOUNCE] BFS CPU scheduler v0.444 for linux-3.12
Date: Tue, 03 Dec 2013 20:43:11 +1100
Message-ID: <10123265.xdzIJ6I9nc@hex>
User-Agent: KMail/4.10.5 (Linux/3.12.0-ck1; KDE/4.10.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is to announce a resync and minor update of the Brain Fuck Scheduler, 
version 0.444 for the latest stable linux kernel. The main changes include a 
resync against linux kernel version 3.12 and a rewritten mechanism for coping 
with suspend to ram/disk and resume issues present in previous versions.

The patch against linux-3.12(.x) is available here:
http://ck.kolivas.org/patches/bfs/3.0/3.12/3.12-sched-bfs-444.patch

A -ck branded linux-3.12-ck2 patch is available here:
http://ck.kolivas.org/patches/3.0/3.12/3.12-ck2/

Note that the other changes in the -ck patch are trivial only and the -ck 
patch is just the latest BFS patch with the cosmetic change of the -ck suffix.

All patches available here:
http://ck.kolivas.org/patches

Code blog:
http://ck-hack.blogspot.com

Enjoy!
お楽しみください

-- 
-ck

