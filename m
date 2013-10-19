Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752477Ab3JSTKp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Oct 2013 15:10:45 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:32493 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751051Ab3JSTKo convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Oct 2013 15:10:44 -0400
Date: Sat, 19 Oct 2013 15:10:39 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Geyslan =?UTF-8?B?R3JlZ8Ozcmlv?= Bem <geyslan@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>, kernel-br <kernel-br@googlegroups.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        open list <linux-kernel@vger.kernel.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: Re: [PATCH] tracing: fix referencing after memory freeing and
 refactors code
Message-ID: <20131019151039.358d9989@gandalf.local.home>
In-Reply-To: <CAGG-pUTE8prwynzWfwR0+MP4q9UTsKOiWYHM4onhzsrqcTbSMA@mail.gmail.com>
References: <1382060696-30746-1-git-send-email-geyslan@gmail.com>
	<20131017224605.2e1d4bab@gandalf.local.home>
	<20131019124312.GA23872@redhat.com>
	<CAGG-pUSk-A=m=cXL85fY+nNgRGQVtG62GouPoANuXFUSrKK6BA@mail.gmail.com>
	<20131019141859.GA30765@redhat.com>
	<CAGG-pUTE8prwynzWfwR0+MP4q9UTsKOiWYHM4onhzsrqcTbSMA@mail.gmail.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 19 Oct 2013 11:41:10 -0300
Geyslan Gregório Bem <geyslan@gmail.com> wrote:
 
> Let's wait Steve's reply about further use of tracing_is_disabled().

Might want to ping me later. This weekend I'm taking my daughter to
colleges, and early Monday morning I'm leaving to Edinburgh (arriving
on Tuesday).

-- Steve

