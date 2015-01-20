Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754943AbbATLRn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 06:17:43 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:41105 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754559AbbATLRl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 06:17:41 -0500
From: Wang Nan <wangnan0@huawei.com>
To: <jolsa@redhat.com>
CC: <jeremie.galarneau@efficios.com>, <bigeasy@linutronix.de>,
        <lizefan@huawei.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/2] perf: convert: two patches for converting syscall tracepoitns.
Date: Tue, 20 Jan 2015 19:07:07 +0800
Message-ID: <1421752029-64237-1-git-send-email-wangnan0@huawei.com>
X-Mailer: git-send-email 1.8.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.107.197.247]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This 2 patches are based on Jiri Olsa's perf repository:

https://git.kernel.org/cgit/linux/kernel/git/jolsa/perf.git/log/?h=perf/core_ctf_convert

Perf data convert to failes when converting perf.data recorded with

 # perf record -a -e syscalls:* sleep 1

The following 2 patches fix it.

Wang Nan (2):
  perf: convert: fix duplicate field names.
  perf: convert: fix signess of value.

 tools/perf/util/data-convert-bt.c | 101 ++++++++++++++++++++++++++++++++++++--
 1 file changed, 96 insertions(+), 5 deletions(-)

-- 
1.8.4

