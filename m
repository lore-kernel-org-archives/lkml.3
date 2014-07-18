Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422898AbaGRSy3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 14:54:29 -0400
Received: from mail-vc0-f181.google.com ([209.85.220.181]:44206 "EHLO
	mail-vc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754825AbaGRSy2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 14:54:28 -0400
MIME-Version: 1.0
In-Reply-To: <20140718144733.5ef33d64@gandalf.local.home>
References: <20140718133609.3125e72d@gandalf.local.home>
	<99d63c5bfe9b320a3b428d773825a37095bf6a51.1405708254.git.tony.luck@intel.com>
	<20140718144733.5ef33d64@gandalf.local.home>
Date: Fri, 18 Jul 2014 11:54:28 -0700
Message-ID: <CA+8MBbLhEx9rnoi2ARnc64bHQLy0pWjUZXNNVinudNpqaMPv=g@mail.gmail.com>
Subject: Re: [PATCH] tracing: Fix wraparound problems in "uptime" tracer
From: Tony Luck <tony.luck@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVja2Vy?= <fweisbec@gmail.com>,
        "m.chehab@samsung.com" <m.chehab@samsung.com>,
        Xie XiuQi <xiexiuqi@huawei.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 18, 2014 at 11:47 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
> Do you think this is worthy of stable and 3.16 material?

Perhaps.  Not sure that I need it (I'm stuck waiting for the extlog_trace pieces
which are now queued in "tip", but won't go in until 3.17).  But I suppose we
should minimize the window where people see the bogus wraparound nanoseconds.

-Tony
