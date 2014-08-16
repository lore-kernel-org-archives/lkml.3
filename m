Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751371AbaHPF7l (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2014 01:59:41 -0400
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:31408 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750833AbaHPF7k convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2014 01:59:40 -0400
From: Con Kolivas <kernel@kolivas.org>
To: linux-kernel@vger.kernel.org
Subject: [ANNOUNCE] BFS CPU scheduler v0.450 with SMT nice support for linux-3.16
Date: Sat, 16 Aug 2014 15:40:13 +1000
Message-ID: <2233658.OcMy7hG7Vc@hex>
User-Agent: KMail/4.13.3 (Linux/3.16.0-ck1; KDE/4.13.3; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is to announce a resync and  update of the Brain Fuck Scheduler, 
version 0.450 for the latest stable linux kernel.

In addition to the usual round of fixes and changes to resync with mainline 
changes, this release brings a new feature of configurable SMT nice support.

The configuration help follows to explain:

Enabling Hyperthreading on Intel CPUs decreases the effectiveness                                                                                   
of the use of 'nice' levels and different scheduling policies                                                                                       
(e.g. realtime) due to sharing of CPU power between hyperthreads.                                                                                   
SMT nice support makes each logical CPU aware of what is running on                                                                                 
its hyperthread siblings, maintaining appropriate distribution of                                                                                   
CPU according to nice levels and scheduling policies at the expense                                                                                 
of slightly increased overhead.      

This code is based on my original idea from ten years ago discussed here:
http://lwn.net/Articles/73614/

A full discussion of the rationale and development follows here:
http://ck-hack.blogspot.com/2014/08/smthyperthreading-nice-and-scheduling.html

The patch against linux-3.16(.x) is available here:
http://ck.kolivas.org/patches/bfs/3.0/3.16/3.16-sched-bfs-450.patch

A -ck branded linux-3.16-ck1 patch is available here:
http://ck.kolivas.org/patches/3.0/3.16/3.16-ck1/

All patches available here:
http://ck.kolivas.org/patches

Code blog:
http://ck-hack.blogspot.com

Enjoy!
お楽しみください

-- 
-ck

