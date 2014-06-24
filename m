Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751243AbaFXCXr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 22:23:47 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:54118 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750827AbaFXCXq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 22:23:46 -0400
X-AuditID: 85900ec0-d0927b9000001514-82-53a8e12fbe99
Subject: [ PATCH  0/2] [BUGFIX] trace-cmd: Fix two small bugs
From: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org, yrl.pp-manager.tt@hitachi.com
Date: Tue, 24 Jun 2014 02:23:40 +0000
Message-ID: <20140624022340.14037.63549.stgit@yuno-kbuild.novalocal>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steven,

I found two small bugs for current trace-cmd, so I fixed those.
1st patch fixes the problem which listen server reader processes abort silently.
2nd patch fixes the problem which trace-cmd cannot record trace data of 
multiple buffers in old kernels.

Thank you,

---

Yoshihiro YUNOMAE (2):
      trace-cmd: [BUGFIX] Initialize handle->options list in tracecmd_attach_cpu_data_fd()
      trace-cmd: [BUGFIX] Don't die if an instance does not have 'current_tracer' file


 trace-output.c |    1 +
 trace-record.c |   12 +++++++++++-
 2 files changed, 12 insertions(+), 1 deletion(-)

-- 
Yoshihiro YUNOMAE
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: yoshihiro.yunomae.ez@hitachi.com
