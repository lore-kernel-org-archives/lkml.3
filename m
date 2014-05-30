Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965051AbaE3RIs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 13:08:48 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.227]:61101 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933527AbaE3RIr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 13:08:47 -0400
Date: Fri, 30 May 2014 13:08:41 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>,
        Namhyung Kim <namhyung@kernel.org>, linux-kernel@vger.kernel.org,
        Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Ingo Molnar <mingo@redhat.com>, yrl.pp-manager.tt@hitachi.com
Subject: Re: [PATCH V2 2/2] ftrace: Introduce nr_saved_cmdlines I/F
Message-ID: <20140530130841.57b3042f@gandalf.local.home>
In-Reply-To: <20140530100223.150a1ea2@gandalf.local.home>
References: <20140220084428.3839.59555.stgit@yunodevel>
	<20140220084433.3839.49609.stgit@yunodevel>
	<20140530100223.150a1ea2@gandalf.local.home>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 May 2014 10:02:23 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> This last part conflicts with my current 3.16 queue. You can see how it
> does in my for-next repo. But I'll be pushing my latest with the
> updates I mentioned above soon and will let you know where to get them.

I just pushed my updates to my repo, which includes your first patch
plus a fix. This may still rebase, I only solidify my "for-next"
branch. But if you rewrite your patch against this branch with my
updates, then I can take it and test it for 3.16. Still have one week
left, but the earlier the better.

 git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git

ftrace/core

SHA1: 4c27e756bc019ec1c11232893af036fdae720a97

-- Steve
