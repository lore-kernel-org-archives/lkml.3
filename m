Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756696Ab3KHEXe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 23:23:34 -0500
Received: from mail-pb0-f51.google.com ([209.85.160.51]:61573 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756196Ab3KHEXb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 23:23:31 -0500
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, jolsa@redhat.com, David Ahern <dsahern@gmail.com>
Subject: [PATCH 0/2] perf: mmap output file - v4
Date: Thu,  7 Nov 2013 21:23:23 -0700
Message-Id: <1383884605-30968-1-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.8.3.4 (Apple Git-47)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Version 4. I think I have addressed all of Ingo's comments plus a few
extra refactorings.

Ingo: updated responses to your comment:

1. out-pages and rounding up to power of 2
   - leveraging the same code used for mmap-pages. A follow on patch
     will do that for both mmap use cases.

2. what happens if a user sets out-pages to zero
   - the parsing function does not allow it

David Ahern (2):
  perf record: Move existing write_output into helper function
  perf record: mmap output file - v4

 tools/perf/Documentation/perf-record.txt |   5 +
 tools/perf/builtin-record.c              | 162 ++++++++++++++++++++++++++++++-
 2 files changed, 166 insertions(+), 1 deletion(-)

-- 
1.8.3.4 (Apple Git-47)

