Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756309Ab3DZNoY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 09:44:24 -0400
Received: from mail-pb0-f44.google.com ([209.85.160.44]:51162 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756216Ab3DZNoX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 09:44:23 -0400
Message-ID: <517A84B2.40209@gmail.com>
Date: Fri, 26 Apr 2013 07:44:18 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>
CC: Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 09/14] perf ftrace: Add 'record' sub-command
References: <1366705872-12132-1-git-send-email-namhyung@kernel.org> <1366705872-12132-10-git-send-email-namhyung@kernel.org> <20130424141241.GG971@krava.brq.redhat.com> <87bo939lgt.fsf@sejong.aot.lge.com>
In-Reply-To: <87bo939lgt.fsf@sejong.aot.lge.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/25/13 12:24 AM, Namhyung Kim wrote:
> But it looks there's a race between cond_wait() and cond_broatcast().
> I'll take a look at that.

Why not use eventfd or a pipe for the signalling instead?

David
