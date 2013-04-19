Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933525Ab3DSVB4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 17:01:56 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:37521 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932474Ab3DSVBy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 17:01:54 -0400
From: Kevin Hilman <khilman@linaro.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, edumazet@google.com,
        darren@dvhart.com, fweisbec@gmail.com, sbw@mit.edu,
        Borislav Petkov <bp@alien8.de>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Christoph Lameter <cl@linux.com>
Subject: Re: [PATCH documentation 1/2] nohz1: Add documentation.
References: <20130411160524.GA30384@linux.vnet.ibm.com>
	<1365696359-30958-1-git-send-email-paulmck@linux.vnet.ibm.com>
Date: Fri, 19 Apr 2013 14:01:49 -0700
In-Reply-To: <1365696359-30958-1-git-send-email-paulmck@linux.vnet.ibm.com>
	(Paul E. McKenney's message of "Thu, 11 Apr 2013 09:05:58 -0700")
Message-ID: <877gjyxmiq.fsf@linaro.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Paul E. McKenney" <paulmck@linux.vnet.ibm.com> writes:

> +KNOWN ISSUES

[...]

> +o	Unless all CPUs are idle, at least one CPU must keep the
> +	scheduling-clock interrupt going in order to support accurate
> +	timekeeping.

At least with the implementation I'm using (Frederic's 3.9-nohz1
branch), at least one CPU is forced to stay out of dyntick-idle
*always*, even if all CPUs are idle.

IMO, this is important to list as a known issue since this will have
its own power implications when the system is mostly idle.

Otherwise, document looks great.  

Reviewed-by: Kevin Hilman <khilman@linaro.org>

Kevin

