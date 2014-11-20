Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756616AbaKTAuR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 19:50:17 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.229]:13367 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756388AbaKTAuQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 19:50:16 -0500
Date: Wed, 19 Nov 2014 19:50:06 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: byungchul.park@lge.com
Cc: mingo@redhat.com, linux-kernel@vger.kernel.org, seungho1.park@lge.com,
        jolsa@redhat.com
Subject: Re: [PATCH v5 1/2] tracing, function_graph: fix micro seconds
 notation in comment
Message-ID: <20141119195006.42b26d46@gandalf.local.home>
In-Reply-To: <1416442535-31188-2-git-send-email-byungchul.park@lge.com>
References: <1416442535-31188-1-git-send-email-byungchul.park@lge.com>
	<1416442535-31188-2-git-send-email-byungchul.park@lge.com>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Nov 2014 09:15:34 +0900
byungchul.park@lge.com wrote:

> From: Byungchul Park <byungchul.park@lge.com>
> 
> Usually, "msecs" notation means milli-seconds, and "usecs" notation
> means micro-seconds. Since the unit used in the code is micro-seconds,
> the notation should be replaced from msecs to usecs.

Hi,

You don't need to resend this patch because I already applied it. You
may have seen my 'for-next' patch series with it.

If this is different than what I applied, let me know.

Thanks,

-- Steve

