Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755583Ab3H2Cyo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 22:54:44 -0400
Received: from mga09.intel.com ([134.134.136.24]:65391 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755492Ab3H2Cyg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 22:54:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,980,1367996400"; 
   d="scan'208";a="370150173"
Message-ID: <1377744875.1643.80.camel@empanada>
Subject: Re: [PATCH v7 00/10] tracing: trace event triggers (repost)
From: Tom Zanussi <tom.zanussi@linux.intel.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: masami.hiramatsu.pt@hitachi.com, linux-kernel@vger.kernel.org
Date: Wed, 28 Aug 2013 21:54:35 -0500
In-Reply-To: <20130828155127.5ca1975a@gandalf.local.home>
References: <cover.1377631572.git.tom.zanussi@linux.intel.com>
	 <20130828155127.5ca1975a@gandalf.local.home>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.1 (3.4.1-2.fc17) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-08-28 at 15:51 -0400, Steven Rostedt wrote:
> On Tue, 27 Aug 2013 14:40:12 -0500
> Tom Zanussi <tom.zanussi@linux.intel.com> wrote:
>  
> > Tom Zanussi (10):
> >   tracing: Add support for SOFT_DISABLE to syscall events
> >   tracing: add basic event trigger framework
> >   tracing: add 'traceon' and 'traceoff' event trigger commands
> >   tracing: add 'snapshot' event trigger command
> >   tracing: add 'stacktrace' event trigger command
> >   tracing: add 'enable_event' and 'disable_event' event trigger
> >     commands
> >   tracing: add and use generic set_trigger_filter() implementation
> >   tracing: update event filters for multibuffer
> >   tracing: add documentation for trace event triggers
> >   tracing: make register/unregister_ftrace_command __init
> 
> In your next series, can you please fix the subjects. The lines should
> start with a capital letter. You did it correctly on your first patch,
> but failed to do it for the others.
> 
> Thanks!
> 

Yeah, will do, and thanks for the review..

Tom

> -- Steve
> 


