Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756019Ab3IIV7V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 17:59:21 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:24447 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755461Ab3IIV7U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 17:59:20 -0400
X-Authority-Analysis: v=2.0 cv=fJG7LOme c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=JDfofD-L5ZgA:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=5p3hctMY2UsA:10 a=7d_E57ReAAAA:8 a=_LpB8dN8cX1VEpSya5kA:9 a=CjuIK1q_8ugA:10 a=D6-X0JM3zdQA:10 a=H87PB8ERALsA:10 a=dxzd4EiVNmEA:10 a=kWZyZOVhklEA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Date: Mon, 9 Sep 2013 17:59:17 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Eric Dumazet <eric.dumazet@gmail.com>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, dhowells@redhat.com, edumazet@google.com,
        darren@dvhart.com, sbw@mit.edu
Subject: Re: [PATCH] rcu: Is it safe to enter an RCU read-side critical
 section?
Message-ID: <20130909175917.794b19bd@gandalf.local.home>
In-Reply-To: <20130909214026.GA8830@Krystal>
References: <20130909130851.GC16280@somewhere>
	<20130909092142.05780991@gandalf.local.home>
	<20130909134505.GF16280@somewhere>
	<20130909135656.GT3966@linux.vnet.ibm.com>
	<20130909101629.32df27a2@gandalf.local.home>
	<20130909161708.GX3966@linux.vnet.ibm.com>
	<20130909123422.7936e868@gandalf.local.home>
	<20130909165836.GB3966@linux.vnet.ibm.com>
	<20130909172908.GA31239@Krystal>
	<20130909175656.GF3966@linux.vnet.ibm.com>
	<20130909214026.GA8830@Krystal>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Sep 2013 17:40:26 -0400
Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:

> Agreed. So how about rcu_is_online() ?

Nope, what about all_your_base_are_belong_to_rcu()?

-- Steve

