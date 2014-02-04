Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753907AbaBDB6j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 20:58:39 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:50165 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752388AbaBDB6f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 20:58:35 -0500
Date: Mon, 3 Feb 2014 20:58:28 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        "zhangwei\(Jovi\)" <jovi.zhangwei@huawei.com>,
        Tom Zanussi <tom.zanussi@linux.intel.com>
Subject: Re: [PATCHSET 0/5] tracing/uprobes: Support multi buffer and event
 trigger
Message-ID: <20140203205828.4e5b1592@gandalf.local.home>
In-Reply-To: <87mwi83hvf.fsf@sejong.aot.lge.com>
References: <1389946120-19610-1-git-send-email-namhyung@kernel.org>
	<87mwi83hvf.fsf@sejong.aot.lge.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 03 Feb 2014 14:06:12 +0900
Namhyung Kim <namhyung@kernel.org> wrote:

> Ping!

Hi Namhyung,

I plan on getting these ready for the 3.15 queue. There was a bit too
much in 3.14 to add these on top of at the last minute.

Currently, I'm working on some bugs at work as well as some things I
found in mainline. I'll be reviewing these when I get a chance.

Thanks,

-- Steve
