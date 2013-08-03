Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753665Ab3HCBzZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 21:55:25 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:24130 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751127Ab3HCBzY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 21:55:24 -0400
X-Authority-Analysis: v=2.0 cv=KJ7Y/S5o c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=7p5mhCWNro8A:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=xRPFay5u69YA:10 a=yU2T06RNWzk63xEkCjYA:9 a=QEXdDO2ut3YA:10 a=5Hg2Hq_6CrYA:10 a=OPW9FsnIz-wA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-ID: <1375494922.22073.38.camel@gandalf.local.home>
Subject: Re: [PATCH] tracing: a few fields of struct trace_iterator are
 zeroed by mistake
From: Steven Rostedt <rostedt@goodmis.org>
To: Andrew Vagin <avagin@openvz.org>
Cc: linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, David Sharp <dhsharp@google.com>,
        Hiraku Toyooka <hiraku.toyooka.gu@hitachi.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Date: Fri, 02 Aug 2013 21:55:22 -0400
In-Reply-To: <1375492884.22073.35.camel@gandalf.local.home>
References: <1375463803-3085183-1-git-send-email-avagin@openvz.org>
	 <1375492884.22073.35.camel@gandalf.local.home>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-08-02 at 21:21 -0400, Steven Rostedt wrote:

> That means that we don't even need the setall in tracing_open_pipe.
> Technically, would shouldn't even allocate it, but for now we should,
> just to be safe.

Your patch is fine as it is. I'll do the other cleanups for 3.12.
Thanks!

-- Steve


