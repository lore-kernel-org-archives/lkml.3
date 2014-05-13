Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161019AbaEMWGw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 18:06:52 -0400
Received: from mail-wi0-f174.google.com ([209.85.212.174]:48286 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755250AbaEMWF5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 18:05:57 -0400
From: Alexis Berlemont <alexis.berlemont@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Alexis Berlemont <alexis.berlemont@gmail.com>, jolsa@redhat.com,
        acme@ghostprotocols.net, dsahern@gmail.com, mingo@kernel.org
Subject: [PATCH 32/34] perf kbuild: relocate the configs generating script
Date: Wed, 14 May 2014 00:03:27 +0200
Message-Id: <1400018609-20486-33-git-send-email-alexis.berlemont@gmail.com>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <1400018609-20486-1-git-send-email-alexis.berlemont@gmail.com>
References: <1400018609-20486-1-git-send-email-alexis.berlemont@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---
 tools/perf/tests/{configs/generate.py => generate_configs.py} | 0
 1 file changed, 0 insertions(+), 0 deletions(-)
 rename tools/perf/tests/{configs/generate.py => generate_configs.py} (100%)

diff --git a/tools/perf/tests/configs/generate.py b/tools/perf/tests/generate_configs.py
similarity index 100%
rename from tools/perf/tests/configs/generate.py
rename to tools/perf/tests/generate_configs.py
-- 
1.9.2

