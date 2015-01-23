Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753949AbbAWGmx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 01:42:53 -0500
Received: from mail4.hitachi.co.jp ([133.145.228.5]:52947 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751705AbbAWGmt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 01:42:49 -0500
Subject: [PATCH -tip/urgent  0/2]kprobes bugfixes around optprobe
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: tixy@linaro.org, Wang Nan <wangnan0@huawei.com>, linux@arm.linux.org.uk,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        lizefan@huawei.com, linux-arm-kernel@lists.infradead.org
Date: Fri, 23 Jan 2015 15:42:17 +0900
Message-ID: <20150123064217.30731.49156.stgit@localhost.localdomain>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

Here are two patches for fixing bugs in kprobes, related to
optprobe and enable/disable kprobe knob.

These are reported and fixed by Wang Nan.
https://lkml.org/lkml/2015/1/5/270
https://lkml.org/lkml/2015/1/19/680

Thank you,


---

Wang Nan (2):
      [BUGFIX]kprobes: set kprobes_all_disarmed earlier to enable re-optimization.
      [BUGFIX]kprobes: makes kprobes/enabled works correctly for optimized kprobes.


 kernel/kprobes.c |   18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

--
Masami HIRAMATSU
Software Platform Research Dpt. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com
