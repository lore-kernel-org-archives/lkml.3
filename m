Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755350AbaCCWOO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 17:14:14 -0500
Received: from terminus.zytor.com ([198.137.202.10]:59827 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754255AbaCCWON (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 17:14:13 -0500
Message-ID: <5314FEA2.2030408@zytor.com>
Date: Mon, 03 Mar 2014 14:13:54 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Petr Mladek <pmladek@suse.cz>, Steven Rostedt <rostedt@goodmis.org>
CC: Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org,
        x86@kernel.org
Subject: Re: [PATCH 1/3] ftrace/x86: One more missing sync after fixup of
 function modification failure
References: <1393258342-29978-1-git-send-email-pmladek@suse.cz> <1393258342-29978-2-git-send-email-pmladek@suse.cz>
In-Reply-To: <1393258342-29978-2-git-send-email-pmladek@suse.cz>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/24/2014 08:12 AM, Petr Mladek wrote:
> If a failure occurs while modifying ftrace function, it bails out and will
> remove the tracepoints to be back to what the code originally was.
> 
> There is missing the final sync run across the CPUs after the fix up is done
> and before the ftrace int3 handler flag is reset.
> 
> Signed-off-by: Petr Mladek <pmladek@suse.cz>
> ---
>  arch/x86/kernel/ftrace.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 

Acked-by: H. Peter Anvin <hpa@linux.intel.com>


