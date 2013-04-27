Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755233Ab3D0N1B (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Apr 2013 09:27:01 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:52891 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752536Ab3D0N1A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Apr 2013 09:27:00 -0400
MIME-Version: 1.0
In-Reply-To: <1365696359-30958-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20130411160524.GA30384@linux.vnet.ibm.com>
	<1365696359-30958-1-git-send-email-paulmck@linux.vnet.ibm.com>
Date: Sat, 27 Apr 2013 15:26:58 +0200
Message-ID: <CAFTL4hwu_bB5ixvNLGezWZGwmjw9Vaikq=MPDVqkO30vqErLwg@mail.gmail.com>
Subject: Re: [PATCH documentation 1/2] nohz1: Add documentation.
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, edumazet@google.com,
        darren@dvhart.com, sbw@mit.edu, Borislav Petkov <bp@alien8.de>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Kevin Hilman <khilman@linaro.org>, Christoph Lameter <cl@linux.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/4/11 Paul E. McKenney <paulmck@linux.vnet.ibm.com>:
> From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
>
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Borislav Petkov <bp@alien8.de>
> Cc: Arjan van de Ven <arjan@linux.intel.com>
> Cc: Kevin Hilman <khilman@linaro.org>
> Cc: Christoph Lameter <cl@linux.com>
> ---

There have been some significant interest and amount of review on this
document. That's a good sign ;-)

We should probably merge the next version of this into tip:timers/nohz
and then iteratively address the remaining reviews. Documentation for
that new full dynticks stuff (and of course dynticks in general) is
critically important. I'm especially worried about warning the users
concerning the current limitations: scheduler stats, fairness, load
balancing and scheduler features in general are not yet well handled
with full dynticks. We'll improve that over time but these issues need
to be visible early.

Thanks!
