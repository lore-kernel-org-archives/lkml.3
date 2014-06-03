Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934164AbaFCWnO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 18:43:14 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.229]:13737 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932164AbaFCWnM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 18:43:12 -0400
Date: Tue, 3 Jun 2014 18:43:10 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v3 2/4] tools lib traceevent: Add options to plugins
Message-ID: <20140603184310.4be2d339@gandalf.local.home>
In-Reply-To: <20140603184154.0a4c031c@gandalf.local.home>
References: <20140603032012.088137043@goodmis.org>
	<20140603032223.896255043@goodmis.org>
	<87lhtecwph.fsf@sejong.aot.lge.com>
	<20140603184154.0a4c031c@gandalf.local.home>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Jun 2014 18:41:54 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> 
> The traceevent plugins allows developers to have their events print out
> information that is more advanced than what can be achieved by the
> trace event format files.
> 
> As these plugins are used on the userspace side of the tracing tools, it
> is only logical that the tools should be able to produce different types
> of output for the events. The types of events still need to be defined by
> the plugins thus we need a way to pass information from the tool to the
> plugin to specify what type of information to be shown.
> 
> Not only does the information need to be passed by the tool to plugin, but
> the plugin also requires a way to notify the tool of what options it can
> provide.
> 
> This builds the plugin option infrastructure that is taken from trace-cmd
> that is used to allow plugins to produce different output based on the
> options specified by the tool.
> 
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

Jiri,

I only sent this patch for v3, as the 1,3,4 are fine. Do you want me to
send a full series? Or can you just pull in v2 of patches 1,3 and 4 and
then v3 of this one?

-- Steve
