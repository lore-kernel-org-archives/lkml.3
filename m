Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756904Ab3GDR6M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 13:58:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12652 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756626Ab3GDR6L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 13:58:11 -0400
Date: Thu, 4 Jul 2013 19:53:24 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung@kernel.org>
Subject: Re: [PATCH 1/2 v6] tracing/uprobes: Support ftrace_event_file base
	multibuffer
Message-ID: <20130704175324.GA2046@redhat.com>
References: <51D556B1.6010402@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51D556B1.6010402@huawei.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/04, zhangwei(Jovi) wrote:

> Support multi-buffer on uprobe-based dynamic events by
> using ftrace_event_file.

Reviewed-by: Oleg Nesterov <oleg@redhat.com>

