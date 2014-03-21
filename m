Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760874AbaCUPYQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 11:24:16 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.232]:32547 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759686AbaCUPYK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 11:24:10 -0400
Date: Fri, 21 Mar 2014 11:24:07 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>
Subject: Re: [PATCH 2/2] tools lib traceevent: Do not call warning()
 directly
Message-ID: <20140321112407.3943d034@gandalf.local.home>
In-Reply-To: <1395192174-26273-2-git-send-email-namhyung@kernel.org>
References: <1395192174-26273-1-git-send-email-namhyung@kernel.org>
	<1395192174-26273-2-git-send-email-namhyung@kernel.org>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Mar 2014 10:22:54 +0900
Namhyung Kim <namhyung@kernel.org> wrote:

> The patch 3a3ffa2e82205 ("tools lib traceevent: Report better error
> message on bad function args") added the error message but it seems
> there's no reason to call warning() directly.
> 
> So change it to do_warning_event() to provide event information too.
> 
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>

Acked-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve
