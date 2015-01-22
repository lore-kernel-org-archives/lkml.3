Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752749AbbAVFmP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 00:42:15 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:30654 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750900AbbAVFmE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 00:42:04 -0500
From: Wang Nan <wangnan0@huawei.com>
To: <jolsa@redhat.com>, <rostedt@goodmis.org>
CC: <jeremie.galarneau@efficios.com>, <bigeasy@linutronix.de>,
        <lizefan@huawei.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH RFC 0/2] tools lib traceevent: introduces priv field to struct format_field.
Date: Thu, 22 Jan 2015 13:35:58 +0800
Message-ID: <1421904958-24106-1-git-send-email-wangnan0@huawei.com>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <20150121143234.GC6835@krava.brq.redhat.com>
References: <20150121143234.GC6835@krava.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.107.197.247]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri Olsa and Steven Rostedt (and others),

Here I post 2 patches. Patch 1 is for Steven Rostedt for his question:

https://lkml.org/lkml/2015/1/21/397

(Jiri, I hope you don't mind me posting this patch if you are working on
 it. I just want to solve the problem.)

The second patch is for Jiri. If the first patch is acceptable, we can
use it to deal with name conversion problem.

Thanks.

Wang Nan (2):
  tools lib traceevent: add priv field to truct format_field.
  perf: convert: fix duplicate field names and avoid reserved keywords.

 tools/lib/traceevent/event-parse.c |  2 +
 tools/lib/traceevent/event-parse.h |  2 +
 tools/perf/util/data-convert-bt.c  | 94 ++++++++++++++++++++++++++++++++++++--
 3 files changed, 94 insertions(+), 4 deletions(-)

-- 
1.8.4

