Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754350AbaDOKx1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 06:53:27 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:51508 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750919AbaDOKx0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 06:53:26 -0400
From: asnast@gmail.com
To: linux-kernel@vger.kernel.org
Cc: rostedt@goodmis.org, Alex Snast <alexsn@il.ibm.com>
Subject: [PATCH 0/2] ftrace: draw_funcgraph.py: Fix regex handling
Date: Tue, 15 Apr 2014 13:53:18 +0300
Message-Id: <1397559200-15520-1-git-send-email-alexsn@il.ibm.com>
X-Mailer: git-send-email 1.9.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alex Snast <alexsn@il.ibm.com>

Hi,

This patch set fixes a small regex handling bug I've encountered while
using draw_funcgraph.py tool.

In addition I've found it more convenient to pass raw function trace input
from files as opposed to stdin only so I've added support for that.

Alex Snast (2):
  ftrace: draw_funcgraph.py: Handle dots in function names
  ftrace: draw_funcgraph.py: Allow reading input from files in addition
    to stdin

 scripts/tracing/draw_functrace.py | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--
1.9.2

