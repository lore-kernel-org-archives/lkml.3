Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756477Ab3IPDkh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Sep 2013 23:40:37 -0400
Received: from mail-pb0-f52.google.com ([209.85.160.52]:55705 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756229Ab3IPDkg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Sep 2013 23:40:36 -0400
Message-ID: <52367DB0.3000105@gmail.com>
Date: Sun, 15 Sep 2013 21:40:32 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Jiri Olsa <jolsa@redhat.com>
CC: linux-kernel@vger.kernel.org, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 05/24] tools list traceevent: Add options support
References: <1378032529-18498-1-git-send-email-jolsa@redhat.com> <1378032529-18498-6-git-send-email-jolsa@redhat.com>
In-Reply-To: <1378032529-18498-6-git-send-email-jolsa@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/1/13 4:48 AM, Jiri Olsa wrote:
> Backporting options support for traceevent lib.

ditto -- where's the code from and last commit id.

>
> It's now possible to use following interface
> to load options for 'struct pevent' object:
>
> void traceevent_add_options(const char *name, struct plugin_option *options);
>    - adds a set of options by a plugin
>
> void traceevent_remove_options(struct plugin_option *options);
>    - removes plugin options that were registered
>
> void traceevent_add_option(const char *name, const char *val);
>    - modifies plugin option

And how is the code used? Take for instance the kvm plugin: would I be 
able to use this interface to pass in a vmlinux path to resolve guest 
symbols or some other option to convert RIPs in kvm tracepoints to symbols?

David
