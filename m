Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753821Ab3KQQXL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Nov 2013 11:23:11 -0500
Received: from mail-pa0-f48.google.com ([209.85.220.48]:47283 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754078Ab3KQQW3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Nov 2013 11:22:29 -0500
From: Ramkumar Ramachandra <artagnon@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@redhat.com>
Subject: [PATCH 5/5] perf completion: rename file to reflect zsh support
Date: Sun, 17 Nov 2013 21:43:27 +0530
Message-Id: <1384704807-15779-6-git-send-email-artagnon@gmail.com>
X-Mailer: git-send-email 1.8.5.rc0.6.gfd75b41
In-Reply-To: <1384704807-15779-1-git-send-email-artagnon@gmail.com>
References: <1384704807-15779-1-git-send-email-artagnon@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Ingo Molnar <mingo@redhat.com>
Signed-off-by: Ramkumar Ramachandra <artagnon@gmail.com>
---
 tools/perf/{bash_completion => perf-completion.sh} | 0
 1 file changed, 0 insertions(+), 0 deletions(-)
 rename tools/perf/{bash_completion => perf-completion.sh} (100%)

diff --git a/tools/perf/bash_completion b/tools/perf/perf-completion.sh
similarity index 100%
rename from tools/perf/bash_completion
rename to tools/perf/perf-completion.sh
-- 
1.8.5.rc0.6.gfd75b41

