Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751592AbaAOVRp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 16:17:45 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:65173 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751248AbaAOVRn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 16:17:43 -0500
Date: Wed, 15 Jan 2014 16:17:36 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        Namhyung Kim <namhyung@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung.kim@lge.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH 07/13] tools lib traceevent: Get rid of die() finally!!
Message-ID: <20140115161736.67c5f1e5@gandalf.local.home>
In-Reply-To: <1389817991-8145-8-git-send-email-acme@infradead.org>
References: <1389817991-8145-1-git-send-email-acme@infradead.org>
	<1389817991-8145-8-git-send-email-acme@infradead.org>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Jan 2014 17:33:05 -0300
Arnaldo Carvalho de Melo <acme@infradead.org> wrote:

> From: Namhyung Kim <namhyung@kernel.org>
> 
> Now all of its users were gone. :)
> 
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> Reviewed-by: Jiri Olsa <jolsa@redhat.com>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Jiri Olsa <jolsa@redhat.com>
> Cc: Namhyung Kim <namhyung.kim@lge.com>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Steven Rostedt <rostedt@goodmis.org>

I just couldn't bring myself to Ack the death of die! }-,:


-- Steve

> Link: http://lkml.kernel.org/r/1389750340-15965-5-git-send-email-namhyung@kernel.org
> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
