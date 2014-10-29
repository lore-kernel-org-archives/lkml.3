Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757145AbaJ2Wme (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 18:42:34 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:59341 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755636AbaJ2Wmd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 18:42:33 -0400
From: Behan Webster <behanw@converseincode.com>
To: andriy.shevchenko@linux.intel.com, aysemelikeyurtoglu@gmail.com,
        matthias.schoepe@studium.uni-erlangen.de, mdcasey@chabloom.com,
        peter.senna@gmail.com, rashika.kheria@gmail.com, standby24x7@gmail.com
Cc: behanw@converseincode.com, akpm@linux-foundation.org,
        andreas.frembs@studium.uni-erlangen.de, devel@driverdev.osuosl.org,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        mahati.chamarthy@gmail.com, peter.p.waskiewicz.jr@intel.com,
        quozl@laptop.org, valentina.manea.m@gmail.com
Subject: [PATCH 0/4] staging, rtl8192e, LLVMLinux: Patches to enable the kernel to be compiled with clang/LLVM
Date: Wed, 29 Oct 2014 15:42:19 -0700
Message-Id: <1414622543-22969-1-git-send-email-behanw@converseincode.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removing a number of warnings generated from compiling stl8192e with clang.

The LLVMLinux project aims to fully build the Linux kernel using both gcc and
clang (the C front end for the LLVM compiler infrastructure project). 

Behan Webster (4):
  staging, rtl8192e, LLVMLinux: Change extern inline to static inline
  staging, rtl8192e, LLVMLinux: Remove unused inline prototype
  staging, rtl8192e, LLVMLinux: Remove unused prototype
  staging, rtl8192e, LLVMLinux: Make static local in inline function
    const

 drivers/staging/rtl8192e/rtllib.h         |  6 ++----
 drivers/staging/rtl8192e/rtllib_softmac.c | 11 ++++++-----
 2 files changed, 8 insertions(+), 9 deletions(-)

-- 
1.9.1

