Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756353Ab3HFUHw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 16:07:52 -0400
Received: from mga02.intel.com ([134.134.136.20]:26516 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752352Ab3HFUHv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 16:07:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,827,1367996400"; 
   d="scan'208";a="382860486"
Message-ID: <52015796.3010007@linux.intel.com>
Date: Tue, 06 Aug 2013 13:07:50 -0700
From: "H. Peter Anvin" <hpa@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Christoph Lameter <cl@gentwo.org>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>
Subject: Re: x86: use this_cpu for debug_stack_usage
References: <000001405493dacb-4d662921-2531-400a-a426-4f76c8066ede-000000@email.amazonses.com>  <1375811455.25420.39.camel@gandalf.local.home>  <0000014054fd1db5-e6fbcc32-2e6c-49b1-83d4-399791ee6829-000000@email.amazonses.com> <1375815765.25420.45.camel@gandalf.local.home>
In-Reply-To: <1375815765.25420.45.camel@gandalf.local.home>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/06/2013 12:02 PM, Steven Rostedt wrote:
> On Tue, 2013-08-06 at 18:56 +0000, Christoph Lameter wrote:
>>> Might as well change is_debug_stack() to use __this_cpu_read() instead
>>> of __get_cpu_var().
> 
> I just noticed that you didn't include the x86 maintainers.
> 
> Reviewed-by: Steven Rostedt <rostedt@goodmis.org>
> 

Looks good to me.

Do you want an ACK from me or do you want me to pick it up?

	-hpa


