Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935060AbaKNDdN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 22:33:13 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.229]:21782 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933512AbaKNDdM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 22:33:12 -0500
Date: Thu, 13 Nov 2014 22:32:53 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: byungchul.park@lge.com
Cc: mingo@redhat.com, linux-kernel@vger.kernel.org, seungho1.park@lge.com,
        jolsa@redhat.com
Subject: Re: [PATCH v2 1/3] tracing, function_graph: fix micro seconds
 notation in comment
Message-ID: <20141113223253.4bfdd1e4@gandalf.local.home>
In-Reply-To: <1415171926-9782-2-git-send-email-byungchul.park@lge.com>
References: <1415171926-9782-1-git-send-email-byungchul.park@lge.com>
	<1415171926-9782-2-git-send-email-byungchul.park@lge.com>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  5 Nov 2014 16:18:44 +0900
byungchul.park@lge.com wrote:

> From: Byungchul Park <byungchul.park@lge.com>
> 
> Usually, "msecs" notation means milli-seconds, and "usecs" notation
> means micro-seconds. Since the unit used in the code is micro-seconds,
> the notation should be replaced from msecs to usecs.
> 
> Signed-off-by: Byungchul Park <byungchul.park@lge.com>

This looks good. I pulled it into my queue.

Thanks!

-- Steve
