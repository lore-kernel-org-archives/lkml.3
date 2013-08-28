Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754284Ab3H1Tvb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 15:51:31 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:8603 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753092Ab3H1Tv3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 15:51:29 -0400
X-Authority-Analysis: v=2.0 cv=DqnUCRD+ c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Wdbh5ZHRpRsA:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=XES-cIolHHYA:10 a=QyXUC8HyAAAA:8 a=maSpgq2L7_GWc9pCiOIA:9 a=CjuIK1q_8ugA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Date: Wed, 28 Aug 2013 15:51:27 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Tom Zanussi <tom.zanussi@linux.intel.com>
Cc: masami.hiramatsu.pt@hitachi.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 00/10] tracing: trace event triggers (repost)
Message-ID: <20130828155127.5ca1975a@gandalf.local.home>
In-Reply-To: <cover.1377631572.git.tom.zanussi@linux.intel.com>
References: <cover.1377631572.git.tom.zanussi@linux.intel.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Aug 2013 14:40:12 -0500
Tom Zanussi <tom.zanussi@linux.intel.com> wrote:
 
> Tom Zanussi (10):
>   tracing: Add support for SOFT_DISABLE to syscall events
>   tracing: add basic event trigger framework
>   tracing: add 'traceon' and 'traceoff' event trigger commands
>   tracing: add 'snapshot' event trigger command
>   tracing: add 'stacktrace' event trigger command
>   tracing: add 'enable_event' and 'disable_event' event trigger
>     commands
>   tracing: add and use generic set_trigger_filter() implementation
>   tracing: update event filters for multibuffer
>   tracing: add documentation for trace event triggers
>   tracing: make register/unregister_ftrace_command __init

In your next series, can you please fix the subjects. The lines should
start with a capital letter. You did it correctly on your first patch,
but failed to do it for the others.

Thanks!

-- Steve

