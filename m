Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756601Ab3A0KwM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2013 05:52:12 -0500
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:43511 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756490Ab3A0KwL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2013 05:52:11 -0500
X-Originating-IP: 217.70.178.139
X-Originating-IP: 150.203.246.47
Date: Sun, 27 Jan 2013 21:51:59 +1100
From: Josh Triplett <josh@joshtriplett.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu
Subject: Re: [PATCH tip/core/rcu 2/2] rcu: Trace callback acceleration
Message-ID: <20130127105159.GC3119@leaf>
References: <20130127001804.GA4122@linux.vnet.ibm.com>
 <1359245901-4432-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1359245901-4432-2-git-send-email-paulmck@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1359245901-4432-2-git-send-email-paulmck@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

You probably don't want to use --chain-reply-to; that makes patch N a
reply to patch N-1 rather than to the cover letter, which creates much
deeper and harder to follow threads.

- Josh Triplett
