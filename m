Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752332AbaAOQUC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 11:20:02 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:64461 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752205AbaAOQT6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 11:19:58 -0500
Date: Wed, 15 Jan 2014 11:19:56 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>
Subject: Re: [PATCH 07/17] tools lib traceevent: Add
 pevent_unregister_print_function()
Message-ID: <20140115111956.7c85b0f2@gandalf.local.home>
In-Reply-To: <1389750340-15965-8-git-send-email-namhyung@kernel.org>
References: <1389750340-15965-1-git-send-email-namhyung@kernel.org>
	<1389750340-15965-8-git-send-email-namhyung@kernel.org>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Jan 2014 10:45:30 +0900
Namhyung Kim <namhyung@kernel.org> wrote:

> When a plugin unloaded it needs to unregister its print handler from
> pevent.  So add unregister function to do it.
> 
> Cc: Jiri Olsa <jolsa@redhat.com>
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> ---

Acked-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve
