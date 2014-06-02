Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752132AbaFBXY1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 19:24:27 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43079 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751616AbaFBXY0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 19:24:26 -0400
Date: Mon, 2 Jun 2014 16:24:24 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dave Chinner <david@fromorbit.com>
Cc: Joe Perches <joe@perches.com>, josh@joshtriplett.org,
        Steven Rostedt <rostedt@goodmis.org>, paulmck@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, mathieu.desnoyers@efficios.com, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, dhowells@redhat.com,
        edumazet@google.com, dvhart@linux.intel.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu
Subject: Re: [PATCH RFC 1/2] MAINTAINERS: Add "R:" designated-reviewers tag
Message-Id: <20140602162424.e95a845a62d9a80d5d0ab605@linux-foundation.org>
In-Reply-To: <20140602231949.GV14410@dastard>
References: <1401729778.5770.20.camel@joe-AO725>
	<20140602174837.GA13257@cloud>
	<1401731968.7323.4.camel@joe-AO725>
	<20140602181658.GX22231@linux.vnet.ibm.com>
	<1401734669.7323.20.camel@joe-AO725>
	<20140602145020.400d4e0c@gandalf.local.home>
	<20140602185504.GA13569@cloud>
	<1401735917.7323.23.camel@joe-AO725>
	<20140602190951.GA13648@cloud>
	<1401736666.7323.25.camel@joe-AO725>
	<20140602231949.GV14410@dastard>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Jun 2014 09:19:49 +1000 Dave Chinner <david@fromorbit.com> wrote:

> Anyone using Reviewed-by without having actually applied and tested
> the patch is mis-using the tag

I think you just described 94.7% of Reviewed-by:s.

> - they should be using Acked-by: if
> all they have done is read the code in their mail program....
