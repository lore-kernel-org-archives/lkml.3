Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754115Ab3HVUZk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 16:25:40 -0400
Received: from mail-lb0-f170.google.com ([209.85.217.170]:48533 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752422Ab3HVUZj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 16:25:39 -0400
From: Max Filippov <jcmvbkbc@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Sam Ravnborg <sam@ravnborg.org>, Guenter Roeck <linux@roeck-us.net>,
        Max Filippov <jcmvbkbc@gmail.com>
Subject: [PATCH v2 0/5] clean up echo -e usage
Date: Fri, 23 Aug 2013 00:25:20 +0400
Message-Id: <1377203125-22934-1-git-send-email-jcmvbkbc@gmail.com>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series cleans up non-portable 'echo -e' usage.
I haven't replaced instances of 'echo -e' under Documentation/ though.
Changes since v1:
- drop /bin/ from remaining echo calls.

Max Filippov (5):
  xtensa: don't use echo -e needlessly
  x86: don't use echo -e needlessly
  raid6/test: replace echo -e with printf
  scripts/checkkconfigsymbols.sh: replace echo -e with printf
  tools/perf/perf-archive.sh: replace echo -e with printf

 arch/x86/Makefile              |    2 +-
 arch/xtensa/Makefile           |    4 ++--
 arch/xtensa/boot/Makefile      |    2 +-
 lib/raid6/test/Makefile        |    2 +-
 scripts/checkkconfigsymbols.sh |    4 ++--
 tools/perf/perf-archive.sh     |    4 ++--
 6 files changed, 9 insertions(+), 9 deletions(-)

-- 
1.7.7.6

