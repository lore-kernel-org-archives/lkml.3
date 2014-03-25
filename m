Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755301AbaCYXuk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 19:50:40 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:46266 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754840AbaCYXtw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 19:49:52 -0400
From: Mitchel Humpherys <mitchelh@codeaurora.org>
To: Rob Landley <rob@landley.net>
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mitchel Humpherys <mitchelh@codeaurora.org>
Subject: [PATCH 2/2] Documentation/SubmittingPatches: remove references to patch-scripts
Date: Tue, 25 Mar 2014 16:49:33 -0700
Message-Id: <1395791373-3694-3-git-send-email-mitchelh@codeaurora.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1395791373-3694-1-git-send-email-mitchelh@codeaurora.org>
References: <1395791373-3694-1-git-send-email-mitchelh@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The link to the tarball for Andrew Morton's patch scripts is dead. These
scripts don't seem to be used for kernel development these days anyways
so just rip out all references to them.

Signed-off-by: Mitchel Humpherys <mitchelh@codeaurora.org>
---
 Documentation/SubmittingPatches       | 5 -----
 Documentation/ja_JP/SubmittingPatches | 5 -----
 Documentation/zh_CN/SubmittingPatches | 4 ----
 3 files changed, 14 deletions(-)

diff --git a/Documentation/SubmittingPatches b/Documentation/SubmittingPatches
index af80689517..3294469efd 100644
--- a/Documentation/SubmittingPatches
+++ b/Documentation/SubmittingPatches
@@ -75,11 +75,6 @@ There are a number of scripts which can aid in this:
 Quilt:
 http://savannah.nongnu.org/projects/quilt
 
-Andrew Morton's patch scripts:
-http://userweb.kernel.org/~akpm/stuff/patch-scripts.tar.gz
-Instead of these scripts, quilt is the recommended patch management
-tool (see above).
-
 
 
 2) Describe your changes.
diff --git a/Documentation/ja_JP/SubmittingPatches b/Documentation/ja_JP/SubmittingPatches
index ff6cb5729c..5d6ae639bf 100644
--- a/Documentation/ja_JP/SubmittingPatches
+++ b/Documentation/ja_JP/SubmittingPatches
@@ -98,11 +98,6 @@ dontdiff ファイルには Linux カーネルのビルドプロセスの過程
 Quilt:
 http://savannah.nongnu.org/projects/quilt
 
-Andrew Morton's patch scripts:
-http://userweb.kernel.org/~akpm/stuff/patch-scripts.tar.gz
-このリンクの先のスクリプトの代わりとして、quilt がパッチマネジメント
-ツールとして推奨されています(上のリンクを見てください)。
-
 2) パッチに対する説明
 
 パッチの中の変更点に対する技術的な詳細について説明してください。
diff --git a/Documentation/zh_CN/SubmittingPatches b/Documentation/zh_CN/SubmittingPatches
index 788ab47303..1d3a10f874 100644
--- a/Documentation/zh_CN/SubmittingPatches
+++ b/Documentation/zh_CN/SubmittingPatches
@@ -82,10 +82,6 @@ Documentation/SubmittingDrivers 。
 Quilt:
 http://savannah.nongnu.org/projects/quilt
 
-Andrew Morton 的补丁脚本:
-http://userweb.kernel.org/~akpm/stuff/patch-scripts.tar.gz
-作为这些脚本的替代，quilt 是值得推荐的补丁管理工具(看上面的链接)。
-
 2)描述你的改动。
 描述你的改动包含的技术细节。
 
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

