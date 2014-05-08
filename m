Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755310AbaEHSGo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 14:06:44 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53720 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753348AbaEHSGl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 14:06:41 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: lwn@lwn.net
Subject: Re: [3.13.y.z extended stable] Linux 3.13.11.2
Date: Thu,  8 May 2014 11:06:37 -0700
Message-Id: <1399572397-23005-2-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1399572397-23005-1-git-send-email-kamal@canonical.com>
References: <1399572397-23005-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

diff --git a/Makefile b/Makefile
index fbbd05f..aa16c23 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 VERSION = 3
 PATCHLEVEL = 13
 SUBLEVEL = 11
-EXTRAVERSION = 1
+EXTRAVERSION = .2
 NAME = King of Alienated Frog Porn
 
 # *DOCUMENTATION*
