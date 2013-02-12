Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933459Ab3BLSMN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 13:12:13 -0500
Received: from mga11.intel.com ([192.55.52.93]:13053 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933332Ab3BLSMM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 13:12:12 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,650,1355126400"; 
   d="scan'208";a="290184110"
Message-ID: <511A85E8.7030303@linux.intel.com>
Date: Tue, 12 Feb 2013 10:11:52 -0800
From: "H. Peter Anvin" <hpa@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>
Subject: Re: [RFC][PATCH] tracing/syscalls: Have ia32 compat syscalls show
 raw format
References: <1360692087.21867.42.camel@gandalf.local.home>
In-Reply-To: <1360692087.21867.42.camel@gandalf.local.home>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

What?

Seriously, this has got to be a bad joke.

Either I'm not getting something here or this is just a nonstarter.

This feels like a hack upon a kluge upon a wart, and something that we'd
have to support forever.

No.  Realize that syscall number does not, and never have, been a unique
identifier for the system call, instead that is the (syscall number, ABI).

	-hpa
