Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754801AbaGOPs1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 11:48:27 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56060 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752450AbaGOPsX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 11:48:23 -0400
Message-ID: <53C54D32.6000000@zytor.com>
Date: Tue, 15 Jul 2014 08:48:02 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
CC: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-arch@vger.kernel.org, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Jiri Kosina <jkosina@suse.cz>,
        Josh Poimboeuf <notifications@github.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: Re: [RFA][PATCH 16/27] ftrace: x86: Remove check of obsolete variable
 function_trace_stop
References: <20140626165221.736847419@goodmis.org> <20140626165851.883708348@goodmis.org>
In-Reply-To: <20140626165851.883708348@goodmis.org>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/26/2014 09:52 AM, Steven Rostedt wrote:
> From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
> 
> Nothing sets function_trace_stop to disable function tracing anymore.
> Remove the check for it in the arch code.
> 
> Cc: H. Peter Anvin <hpa@linux.intel.com>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

Acked-by: H. Peter Anvin <hpa@linux.intel.com>

