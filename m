Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752711AbaBSCws (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 21:52:48 -0500
Received: from science.horizon.com ([71.41.210.146]:22892 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752302AbaBSCwr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 21:52:47 -0500
Date: 18 Feb 2014 21:52:42 -0500
Message-ID: <20140219025242.9985.qmail@science.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: josh@joshtriplett.org, paulmck@linux.vnet.ibm.com
Subject: Re: [PATCH tip/core/rcu 15/55] rcutorture: Abstract rcu_torture_random()
Cc: akpm@linux-foundation.org, darren@dvhart.com, dhowells@redhat.com,
        dipankar@in.ibm.com, edumazet@google.com, fweisbec@gmail.com,
        laijs@cn.fujitsu.com, linux-kernel@vger.kernel.org, linux@horizon.com,
        mathieu.desnoyers@efficios.com, mingo@kernel.org, niv@us.ibm.com,
        oleg@redhat.com, peterz@infradead.org, rostedt@goodmis.org,
        sbw@mit.edu, tglx@linutronix.de
In-Reply-To: <20140218002743.GF19929@thin>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Josh Triplett wrote:
> I suspect the fastest way to find out about any existing generator with
> the desired properties would be to post this one as a patch to the
> random number infrastructure and read the resulting replies. :)

But thank you for not choosing the most irritating alternative simply
on the grounds that "it gets a faster response".
