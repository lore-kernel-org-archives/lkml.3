Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758020Ab3HHQr5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 12:47:57 -0400
Received: from mail-vb0-f74.google.com ([209.85.212.74]:51141 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751006Ab3HHQr4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 12:47:56 -0400
From: Alexander Z Lam <azl@google.com>
To: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
Cc: Alexander Z Lam <azl@google.com>, David Sharp <dhsharp@google.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>,
        Alexander Z Lam <lambchop468@gmail.com>
Subject: [PATCH v2 0/1] tracing: Make tracing_cpumask available for all instances
Date: Thu,  8 Aug 2013 09:47:44 -0700
Message-Id: <cover.1375980149.git.azl@google.com>
X-Mailer: git-send-email 1.8.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry, it slipped my mind to actually test tracing_cpumask_read().

Changed
	struct trace_array *tr = file_inode(filp);
to
	struct trace_array *tr = file_inode(filp)->i_private;

Alexander Z Lam (1):
  tracing: Make tracing_cpumask available for all instances

 kernel/trace/trace.c | 37 ++++++++++++++++++++-----------------
 kernel/trace/trace.h |  1 +
 2 files changed, 21 insertions(+), 17 deletions(-)

-- 
1.8.3

