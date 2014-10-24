Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756405AbaJXMeV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 08:34:21 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:56692 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756090AbaJXMeU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 08:34:20 -0400
From: Masanari Iida <standby24x7@gmail.com>
To: catalin.marinas@arm.com, corbet@lwn.net, linux-kernel@vger.kernel.org
Cc: Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH 0/2] Documenation: kmemleak: Add an explanation about CONFIG_DEBUG_KMEMLEAK_DEFAULT_OFF=y case. 
Date: Fri, 24 Oct 2014 21:24:58 +0900
Message-Id: <1414153500-29150-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 2.1.2.451.g98349e5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Following 2 patches add an explanation about CONFIG_DEBUG_KMEMLEAK_DEFAULT_OFF=y 
case.

Masanari Iida (2):
  Documentation: Add default kmemleak off case in kernel-parameters.txt
  Documentation: Add CONFIG_DEBUG_KMEMLEAK_DEFAULT_OFF case

 Documentation/kernel-parameters.txt | 2 ++
 Documentation/kmemleak.txt          | 4 ++++
 2 files changed, 6 insertions(+)

-- 
2.1.2.451.g98349e5

