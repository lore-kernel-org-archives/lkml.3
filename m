Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752262AbaIYBOr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 21:14:47 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.232]:9725 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751281AbaIYBOp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 21:14:45 -0400
Date: Wed, 24 Sep 2014 21:14:40 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Shuah Khan <shuah.kh@samsung.com>,
        Tom Zanussi <tom.zanussi@linux.intel.com>,
        Oleg Nesterov <oleg@redhat.com>, Fengguang Wu <fengguang.wu@intel.com>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [RFC][PATCH] ftracetest: Add a couple of ftrace test cases
Message-ID: <20140924211440.2c170de4@gandalf.local.home>
In-Reply-To: <54236339.7060506@hitachi.com>
References: <20140923173846.603cb49c@gandalf.local.home>
	<5422336A.6030304@hitachi.com>
	<20140924114235.4287f4a1@gandalf.local.home>
	<20140924115811.6eeeab8c@gandalf.local.home>
	<54236339.7060506@hitachi.com>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Sep 2014 09:35:05 +0900
Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:

> (2014/09/25 0:58), Steven Rostedt wrote:
> > On Wed, 24 Sep 2014 11:42:35 -0400
> > Steven Rostedt <rostedt@goodmis.org> wrote:
> > 
> >>> I think you'd better use exit_unsupported/exit_xfail to notify
> >>> that the test target is not configured, or expected to fail.
> >>
> > 
> > Are these functions defined anywhere? I don't seem them in your v5
> > patch set, or in selftests anywhere.
> 
> Hmm, could you check my 4/4 patch in the series??
> http://www.mail-archive.com/linux-kernel@vger.kernel.org/msg730578.html

Hmm, I somehow missed this. Can you check to make sure my for-next
patches are your latest version. I'll pull in 4/4 tomorrow.

Thanks,

-- Steve
