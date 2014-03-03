Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755243AbaCCWNX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 17:13:23 -0500
Received: from terminus.zytor.com ([198.137.202.10]:59816 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754332AbaCCWNW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 17:13:22 -0500
Message-ID: <5314FE46.3060003@zytor.com>
Date: Mon, 03 Mar 2014 14:12:22 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
CC: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Petr Mladek <pmladek@suse.cz>, stable@vger.kernel.org
Subject: Re: [RFA][PATCH 1/5] ftrace/x86: Run a sync after fixup on failure
References: <20140227154616.703252665@goodmis.org> <20140227154922.957070805@goodmis.org>
In-Reply-To: <20140227154922.957070805@goodmis.org>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/27/2014 07:46 AM, Steven Rostedt wrote:
> The second bug was that the removal of the breakpoints required the
> "within()" logic updates instead of accessing the ip address directly.

Please update this bit to clarify, as we discussed on IRC.

Otherwise:

Acked-by: H. Peter Anvin <hpa@linux.intel.com>

