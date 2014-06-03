Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965447AbaFCWKk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 18:10:40 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:53434 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965353AbaFCWJS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 18:09:18 -0400
From: Alexis Berlemont <alexis.berlemont@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Alexis Berlemont <alexis.berlemont@gmail.com>, jolsa@redhat.com,
        dsahern@gmail.com, mingo@kernel.org, sam@ravnborg.org, mmarek@suse.cz
Subject: [PATCH 30/32] perf kbuild: relocate the configs generating script
Date: Wed,  4 Jun 2014 00:06:23 +0200
Message-Id: <1401833185-10347-31-git-send-email-alexis.berlemont@gmail.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1401833185-10347-1-git-send-email-alexis.berlemont@gmail.com>
References: <1401833185-10347-1-git-send-email-alexis.berlemont@gmail.com>
In-Reply-To: <CAMesUR5h0687dTFCDC3LhKSOFyKTFmH3vUjU+p6XuOpawPUwxQ@mail.gmail.com>
References: <CAMesUR5h0687dTFCDC3LhKSOFyKTFmH3vUjU+p6XuOpawPUwxQ@mail.gmail.com>
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
1.9.3

