Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753387Ab3JSTgA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Oct 2013 15:36:00 -0400
Received: from mail-ie0-f176.google.com ([209.85.223.176]:52585 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750901Ab3JSTf7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Oct 2013 15:35:59 -0400
MIME-Version: 1.0
In-Reply-To: <20131019151039.358d9989@gandalf.local.home>
References: <1382060696-30746-1-git-send-email-geyslan@gmail.com>
	<20131017224605.2e1d4bab@gandalf.local.home>
	<20131019124312.GA23872@redhat.com>
	<CAGG-pUSk-A=m=cXL85fY+nNgRGQVtG62GouPoANuXFUSrKK6BA@mail.gmail.com>
	<20131019141859.GA30765@redhat.com>
	<CAGG-pUTE8prwynzWfwR0+MP4q9UTsKOiWYHM4onhzsrqcTbSMA@mail.gmail.com>
	<20131019151039.358d9989@gandalf.local.home>
Date: Sat, 19 Oct 2013 16:35:59 -0300
Message-ID: <CAGG-pUQGa0E9G96t8C1TM6S7bM+krn+UyMKh6P+KNHg5AFyWNw@mail.gmail.com>
Subject: Re: [PATCH] tracing: fix referencing after memory freeing and
 refactors code
From: =?UTF-8?Q?Geyslan_Greg=C3=B3rio_Bem?= <geyslan@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Oleg Nesterov <oleg@redhat.com>, kernel-br <kernel-br@googlegroups.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        open list <linux-kernel@vger.kernel.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/10/19 Steven Rostedt <rostedt@goodmis.org>:
> On Sat, 19 Oct 2013 11:41:10 -0300
> Geyslan Gregório Bem <geyslan@gmail.com> wrote:
>
>> Let's wait Steve's reply about further use of tracing_is_disabled().
>
> Might want to ping me later. This weekend I'm taking my daughter to
> colleges, and early Monday morning I'm leaving to Edinburgh (arriving
> on Tuesday).
>
> -- Steve
>

There is no problem, weekends are sacred to me. It's family time.

o/
--Geyslan
