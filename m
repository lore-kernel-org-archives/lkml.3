Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934344Ab3CMWei (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 18:34:38 -0400
Received: from mail-da0-f54.google.com ([209.85.210.54]:63504 "EHLO
	mail-da0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933273Ab3CMWeh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 18:34:37 -0400
From: Vinson Lee <vlee@twitter.com>
To: linux-kernel@vger.kernel.org
Cc: Vinson Lee <vlee@twitter.com>
Subject: [PATCH v3] perf tools: Fix LIBNUMA build with glibc 2.12 and older.
Date: Wed, 13 Mar 2013 15:34:23 -0700
Message-Id: <1363214064-4671-1-git-send-email-vlee@twitter.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <20130311083652.GE12742@gmail.com>
References: <20130311083652.GE12742@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Updated patch after Ingo Molnar's feedback.

- Added comments about glibc compatibility and PA-RISC special case.
- Made #ifdef blocks multi-level.

Vinson Lee (1):
  perf tools: Fix LIBNUMA build with glibc 2.12 and older.

 tools/perf/bench/bench.h |   24 ++++++++++++++++++++++++
 1 files changed, 24 insertions(+), 0 deletions(-)

