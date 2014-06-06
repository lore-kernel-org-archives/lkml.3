Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752777AbaFFIqa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 04:46:30 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.227]:34233 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752073AbaFFIpp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 04:45:45 -0400
Date: Fri, 6 Jun 2014 04:45:35 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Cc: linux-kernel@vger.kernel.org,
        Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Ingo Molnar <mingo@redhat.com>, yrl.pp-manager.tt@hitachi.com
Subject: Re: [PATCH ftrace/core] tracing: Remove return value in
 event_trace_self_tests() when top_trace_array() returns NULL
Message-ID: <20140606044535.6430c581@gandalf.local.home>
In-Reply-To: <53916033.1040908@hitachi.com>
References: <20140605234623.484afaf8@gandalf.local.home>
	<20140606062844.7955.61919.stgit@yunodevel>
	<53916033.1040908@hitachi.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 06 Jun 2014 15:31:15 +0900
Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com> wrote:

> Hi Steven,
> 
> Thank you for applying my patches.
> I received build warning report from kbuild test bot,
> so I fixed it. Would you apply this patch?
>

My tests also caught it. I pushed to my ftrace/core branch which is
allowed to rebase (I push only to trigger Wu's bots). I'll just fold
that fix into the original patch.

Thanks,

-- Steve
