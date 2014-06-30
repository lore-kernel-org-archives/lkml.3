Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756663AbaF3Q51 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 12:57:27 -0400
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:56696 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756603AbaF3Q5Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 12:57:25 -0400
Date: Mon, 30 Jun 2014 22:27:18 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Tom Zanussi <tom.zanussi@linux.intel.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] uprobes: Change unregister/apply to WARN() if
 uprobe/consumer is gone
Message-ID: <20140630165718.GB5619@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20140627170116.GA18298@redhat.com>
 <20140627170140.GA18322@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20140627170140.GA18322@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14063016-2674-0000-0000-000000A3C86C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Oleg Nesterov <oleg@redhat.com> [2014-06-27 19:01:40]:

> Add WARN_ON's into uprobe_unregister() and uprobe_apply() to ensure
> that nobody tries to play with the dead uprobe/consumer. This helps
> to catch the bugs like the one fixed by the previous patch.
> 
> In the longer term we should fix this poorly designed interface.
> uprobe_register() should return "struct uprobe *" which should be
> passed to apply/unregister. Plus other semantic changes, see the
> changelog in commit 41ccba029e94.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Acked-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>

-- 
Thanks and Regards
Srikar Dronamraju

