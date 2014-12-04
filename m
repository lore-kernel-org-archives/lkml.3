Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753779AbaLDLpr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 06:45:47 -0500
Received: from mail7.hitachi.co.jp ([133.145.228.42]:38353 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753621AbaLDLpq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 06:45:46 -0500
Subject: [PATCH 0/2] ftracetest: ftracetest updates
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Theodore Tso <tytso@mit.edu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>
Date: Thu, 04 Dec 2014 14:41:09 -0500
Message-ID: <20141204194109.7376.84279.stgit@localhost.localdomain>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here are two patches to improve ftracetest. The first one fixes
a bug in dash environment, and the second one adds --verbose to
show all stdout messages of the testcases when running ftracetest.

Thank you,

---

Masami Hiramatsu (2):
      ftracetest: Fix to show descriptions on dash
      ftracetest: Add --verbose option for showing echo output


 tools/testing/selftests/ftrace/ftracetest |   36 ++++++++++++++++++++---------
 1 file changed, 25 insertions(+), 11 deletions(-)

--

