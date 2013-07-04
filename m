Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964845Ab3GDMpj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 08:45:39 -0400
Received: from mail-pb0-f54.google.com ([209.85.160.54]:64522 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932956Ab3GDMph (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 08:45:37 -0400
From: Ramkumar Ramachandra <artagnon@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 4/7] perf completion: modernize style
Date: Thu,  4 Jul 2013 18:11:28 +0530
Message-Id: <1372941691-14684-5-git-send-email-artagnon@gmail.com>
X-Mailer: git-send-email 1.8.3.1.643.gebeea52.dirty
In-Reply-To: <1372941691-14684-1-git-send-email-artagnon@gmail.com>
References: <1372941691-14684-1-git-send-email-artagnon@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Ramkumar Ramachandra <artagnon@gmail.com>
---
 tools/perf/bash_completion | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/bash_completion b/tools/perf/bash_completion
index d2598be..8c04f5d 100644
--- a/tools/perf/bash_completion
+++ b/tools/perf/bash_completion
@@ -7,7 +7,7 @@ function_exists()
 }
 
 function_exists __ltrim_colon_completions ||
-__ltrim_colon_completions()
+__ltrim_colon_completions ()
 {
 	if [[ "$1" == *:* && "$COMP_WORDBREAKS" == *:* ]]; then
 		# Remove colon-word prefix from COMPREPLY items
@@ -20,7 +20,7 @@ __ltrim_colon_completions()
 }
 
 type perf &>/dev/null &&
-_perf()
+_perf ()
 {
 	local cur prev cmd
 
-- 
1.8.3.1.643.gebeea52.dirty

