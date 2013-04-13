Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754742Ab3DMCOU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 22:14:20 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:9903 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752426Ab3DMCOT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 22:14:19 -0400
X-Authority-Analysis: v=2.0 cv=aOZyWMBm c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=hhH8zwMFE54A:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=bUzm9BIBfnIA:10 a=mt_FnhQuZolAWLElMlIA:9 a=QEXdDO2ut3YA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1365819257.9609.109.camel@gandalf.local.home>
Subject: Re: [PATCH 5/6] tools lib traceevent: Add page_size field to pevent
From: Steven Rostedt <rostedt@goodmis.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>
Date: Fri, 12 Apr 2013 22:14:17 -0400
In-Reply-To: <1365818888.1769.49.camel@leonhard>
References: <1365681898-19897-1-git-send-email-namhyung@kernel.org>
	 <1365681898-19897-5-git-send-email-namhyung@kernel.org>
	 <1365691175.9609.33.camel@gandalf.local.home>
	 <1365691255.9609.34.camel@gandalf.local.home>
	 <1365815846.1769.11.camel@leonhard>
	 <1365816410.9609.106.camel@gandalf.local.home>
	 <1365818888.1769.49.camel@leonhard>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-04-13 at 11:08 +0900, Namhyung Kim wrote:
> 2013-04-12 (금), 21:26 -0400, Steven Rostedt:

> I think it only affects trace-cmd as it's the only user that accesses
> raw ring-buffer contents for now.  I found it during writing code also
> accesses the ring buffer (with kbuffer code) - perf ftrace. :)
> 
> But the code is in a very early stage and needs to handle so many things
> before posting to the list.  So I just wanted to post a part of the
> preparation first.

I understand. But people tend to not like things in upstream that has no
user. If Arnaldo wants to include it, that's his decision. I'm just
worried that if it takes a while before your other work gets mainline,
people might start sending patches to remove that code and your stuff
will suddenly break.

-- Steve


