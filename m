Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752777AbaAPCFe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 21:05:34 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:40723 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752725AbaAPCFS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 21:05:18 -0500
Date: Wed, 15 Jan 2014 21:05:14 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Namhyung Kim <namhyung.kim@lge.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Jiri Olsa <jolsa@redhat.com>
Subject: Re: [PATCH 06/17] tools lib traceevent: Add
 pevent_unregister_event_handler()
Message-ID: <20140115210514.66e07b11@gandalf.local.home>
In-Reply-To: <87y52g7knm.fsf@sejong.aot.lge.com>
References: <1389750340-15965-1-git-send-email-namhyung@kernel.org>
	<1389750340-15965-7-git-send-email-namhyung@kernel.org>
	<20140115111839.73d85422@gandalf.local.home>
	<52D7211C.9030903@lge.com>
	<20140115205259.017a644f@gandalf.local.home>
	<87y52g7knm.fsf@sejong.aot.lge.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Jan 2014 10:58:05 +0900
Namhyung Kim <namhyung@kernel.org> wrote:

> Thanks, can I add your ack with this change?

Yeah, go ahead.

-- Steve

