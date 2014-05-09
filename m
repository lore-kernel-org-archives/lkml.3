Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756039AbaEIB10 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 21:27:26 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.227]:6442 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754039AbaEIB1Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 21:27:25 -0400
Date: Thu, 8 May 2014 21:27:23 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Cc: <peterz@infradead.org>, <bsegall@google.com>, <mingo@redhat.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sched: Distinguish sched_wakeup event when wake up a
 task which did schedule out or not.
Message-ID: <20140508212723.5bfbbf96@gandalf.local.home>
In-Reply-To: <536C1E50.5020806@cn.fujitsu.com>
References: <53683B14.3060702@cn.fujitsu.com>
	<1399341154-11785-1-git-send-email-yangds.fnst@cn.fujitsu.com>
	<536C1E50.5020806@cn.fujitsu.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 May 2014 09:16:16 +0900
Dongsheng Yang <yangds.fnst@cn.fujitsu.com> wrote:

> Hi steven, does this version look good to you?

The patch looks fine to me. Peter, are you OK with it?

The change log needs a little cleaning up though. But I'm sure we can
do that for you.

Acked-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve
