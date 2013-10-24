Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756109Ab3JXTOn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 15:14:43 -0400
Received: from mail-oa0-f54.google.com ([209.85.219.54]:55400 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754844Ab3JXTOl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 15:14:41 -0400
From: Seth Forshee <seth.forshee@canonical.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Seth Forshee <seth.forshee@canonical.com>
Subject: [PATCH trace-cmd 0/5] Miscellaneous fixes for trace-cmd
Date: Thu, 24 Oct 2013 14:14:29 -0500
Message-Id: <1382642074-15567-1-git-send-email-seth.forshee@canonical.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steve,

I've been working on getting trace-cmd packaged for Debian. In the
process I had to make several changes to either fix bugs or get the
tools to stop complaining. All of these look appropriate for upstream,
so I'm sending them your way.

Thanks,
Seth


Seth Forshee (5):
  trace-cmd/listen: Remove use of sighandler_t
  build: Install data files without execute permissions
  Add missing libgen.h includes
  Documentation: Add kernelshark.1.txt
  build: Use CFLAGS and LDFLAGS when building python bits

 Documentation/Makefile          | 13 ++++++------
 Documentation/kernelshark.1.txt | 46 +++++++++++++++++++++++++++++++++++++++++
 Makefile                        | 32 +++++++++++++++++++---------
 kernel-shark.c                  |  1 +
 trace-graph-main.c              |  1 +
 trace-listen.c                  |  2 +-
 trace-view-main.c               |  1 +
 7 files changed, 79 insertions(+), 17 deletions(-)
 create mode 100644 Documentation/kernelshark.1.txt

