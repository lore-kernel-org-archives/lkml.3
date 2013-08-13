Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757865Ab3HMOrJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 10:47:09 -0400
Received: from mga02.intel.com ([134.134.136.20]:10689 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756543Ab3HMOrH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 10:47:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,869,1367996400"; 
   d="scan'208";a="380259922"
Message-ID: <520A46D6.90005@linux.intel.com>
Date: Tue, 13 Aug 2013 07:46:46 -0700
From: "H. Peter Anvin" <hpa@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
        gcc <gcc@gcc.gnu.org>, Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        David Daney <ddaney.cavm@gmail.com>,
        Behan Webster <behanw@converseincode.com>
Subject: Re: [RFC] gcc feature request: Moving blocks into sections
References: <1375721715.22073.80.camel@gandalf.local.home> <20130812091707.GB27162@twins.programming.kicks-ass.net> <5208F78A.3000708@linux.intel.com> <20130812160950.GT3008@twins.programming.kicks-ass.net> <52091FB9.4080805@linux.intel.com> <20130813075048.GR27162@twins.programming.kicks-ass.net>
In-Reply-To: <20130813075048.GR27162@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Mon, Aug 12, 2013 at 10:47:37AM -0700, H. Peter Anvin wrote:
>> Since we really doesn't want to...

Ow.  Can't believe I wrote that.

	-hpa

