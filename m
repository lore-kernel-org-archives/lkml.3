Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756805AbaGNTWN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 15:22:13 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.231]:50656 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756501AbaGNTWC convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 15:22:02 -0400
Date: Mon, 14 Jul 2014 15:21:58 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Tom Zanussi <tom.zanussi@linux.intel.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/7] tracing: change filter_free_subsystem_*() to check
 ->subsystem rather then ->name
Message-ID: <20140714152158.19919949@gandalf.local.home>
In-Reply-To: <1405346299.1745.21.camel@leonhard>
References: <20140711190655.GA19549@redhat.com>
	<1405346299.1745.21.camel@leonhard>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Jul 2014 22:58:19 +0900
Namhyung Kim <namhyung@kernel.org> wrote:

> 2014-07-11 (금), 21:06 +0200, Oleg Nesterov:
> > filter_free_subsystem_preds() and filter_free_subsystem_filters()
> > can rely on file->system->subsystem and avoid strcmp().
> 
> I guess the same can go to the replace_system_preds() too.
> 

And it looks like you can pass dir there instead of system as well.

-- Steve
