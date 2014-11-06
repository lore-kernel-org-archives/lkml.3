Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751546AbaKFNmH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 08:42:07 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:65293 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751062AbaKFNmD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 08:42:03 -0500
Date: Thu, 6 Nov 2014 08:41:49 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Namhyung Kim <namhyung@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/3] ftracetest: Use logfile name supported by busybox's
 mktemp
Message-ID: <20141106084149.79c2b5d3@gandalf.local.home>
In-Reply-To: <545AE716.7060101@hitachi.com>
References: <1415239470-28705-1-git-send-email-namhyung@kernel.org>
	<545AE716.7060101@hitachi.com>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 06 Nov 2014 12:12:22 +0900
 
> > 
> >   [1] Basic trace file check/linux/tools/testing/selftests/ftrace/ftracetest: line 244: can't create : nonexistent directory
> >   /linux/tools/testing/selftests/ftrace/ftracetest: line 244: can't create : nonexistent directory
> > 						  [FAIL]
> > 
> > Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> 
> Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

I pulled all three in.

Thanks Namhyung!

-- Steve
