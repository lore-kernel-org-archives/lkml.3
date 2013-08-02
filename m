Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755380Ab3HBSch (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 14:32:37 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:14428 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753017Ab3HBScg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 14:32:36 -0400
X-Authority-Analysis: v=2.0 cv=P6i4d18u c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=7p5mhCWNro8A:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=xRPFay5u69YA:10 a=5EJbLc2318gLgB091eEA:9 a=QEXdDO2ut3YA:10 a=8sdsUPW-wLkA:10 a=g-seKyyuCv8A:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-ID: <1375468355.22073.9.camel@gandalf.local.home>
Subject: Re: [PATCH] tracing: a few fields of struct trace_iterator are
 zeroed by mistake
From: Steven Rostedt <rostedt@goodmis.org>
To: David Sharp <dhsharp@google.com>
Cc: Andrew Vagin <avagin@openvz.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Hiraku Toyooka <hiraku.toyooka.gu@hitachi.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Date: Fri, 02 Aug 2013 14:32:35 -0400
In-Reply-To: <CAJL_ektQ=q2T6CUR0bKig088DWaOSUd-yek2S_dT3fjRRfrf0Q@mail.gmail.com>
References: <1375463803-3085183-1-git-send-email-avagin@openvz.org>
	 <CAJL_ektQ=q2T6CUR0bKig088DWaOSUd-yek2S_dT3fjRRfrf0Q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-08-02 at 11:15 -0700, David Sharp wrote:

> Wow. That is a terrible hack. Thanks for noticing it.

Why thank you :-)

It's a hack from doing things that way else where and long ago.

> 
> If I may suggest a way better idea: put these zeroed-in-pipe_read
> members in an embedded anonymous structure, and zero the structure in
> pipe_read.

Sure, sounds like a fix for 3.12.

-- Steve


