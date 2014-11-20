Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756976AbaKTNv3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 08:51:29 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.229]:53709 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752008AbaKTNua (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 08:50:30 -0500
Date: Thu, 20 Nov 2014 08:50:28 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: byungchul.park@lge.com, mingo@redhat.com, linux-kernel@vger.kernel.org,
        seungho1.park@lge.com, jolsa@redhat.com
Subject: Re: [PATCH v4 3/3] tracing: add additional marks to signal very
 large delay
Message-ID: <20141120085028.29efe8cf@gandalf.local.home>
In-Reply-To: <87egsypfjs.fsf@sejong.aot.lge.com>
References: <1416290246-882-1-git-send-email-byungchul.park@lge.com>
	<1416290246-882-4-git-send-email-byungchul.park@lge.com>
	<20141119133515.1caa293e@gandalf.local.home>
	<87egsypfjs.fsf@sejong.aot.lge.com>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Nov 2014 15:11:19 +0900
Namhyung Kim <namhyung@kernel.org> wrote:


> >> +	  '#' - greater than 1000 microsecond
> >> +	  '!' - greater than 100 microsecond
> >> +	  '+' - greater than 10 microsecond
> 
> I've noticed that it's now changed from 1 msec to 10 msec.  Is it okay?

Yeah, I didn't like the inconsistency between the two tracers, and not
only that, I  found the 1 microsecond mark rather useless. 10 is a much
better value. I don't think people will complain about this API change.

-- Steve
