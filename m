Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761654Ab3IDARs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 20:17:48 -0400
Received: from terminus.zytor.com ([198.137.202.10]:47485 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761544Ab3IDARq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 20:17:46 -0400
Message-ID: <52267BD1.1070608@zytor.com>
Date: Tue, 03 Sep 2013 17:16:17 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Jiri Olsa <jolsa@redhat.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: Re: [RFC][PATCH 17/18 v2] ftrace/cpuidle/x86: Mark functions that
 are RCU unsafe
References: <20130831051117.884125230@goodmis.org> <20130831051703.241036187@goodmis.org>
In-Reply-To: <20130831051703.241036187@goodmis.org>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/30/2013 10:11 PM, Steven Rostedt wrote:
> From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
> 
> Some callbacks of the function tracer use rcu_read_lock(). This means that
> there's places that can not be traced because RCU is not tracking the CPU
> for various reasons (like NO_HZ_FULL and coming back from userspace).
> 
> Thes functions need to be marked so that callbacks that use RCU do not
> trace them.
> 
> Cc: H. Peter Anvin <hpa@zytor.com>
> Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

Acked-by: H. Peter Anvin <hpa@zytor.com>

