Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754486Ab3FTIJb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 04:09:31 -0400
Received: from mms1.broadcom.com ([216.31.210.17]:4158 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752359Ab3FTIJV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 04:09:21 -0400
X-Server-Uuid: 06151B78-6688-425E-9DE2-57CB27892261
Message-ID: <51C2B8AB.8060709@broadcom.com>
Date: Thu, 20 Jun 2013 10:09:15 +0200
From: "Arend van Spriel" <arend@broadcom.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510
 Thunderbird/17.0.6
MIME-Version: 1.0
To: "Steven Rostedt" <rostedt@goodmis.org>
cc: linux-kernel@vger.kernel.org, "Ingo Molnar" <mingo@kernel.org>,
        "Frederic Weisbecker" <fweisbec@gmail.com>,
        "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [for-next][PATCH 08/12] tracing: Add binary & filter for
 events
References: <20130620033516.003166252@goodmis.org>
 <20130620033639.723900482@goodmis.org>
In-Reply-To: <20130620033639.723900482@goodmis.org>
X-WSS-ID: 7DDC685A31W39449698-01-01
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/20/2013 05:35 AM, Steven Rostedt wrote:
> By allowing a binary '&' operation, this gives the user the ability to
> test a bit.
>
> Note, a binary '|' is not added, as it doesn't make sense as fields must
> be compared to constants (for now), and ORing a constant will always return
> true.
>
> Link:http://lkml.kernel.org/r/1371057385.9844.261.camel@gandalf.local.home
>
> Suggested-by: Arend van Spriel<arend@broadcom.com>

Actually, my attempt was triggered by the trace-cmd manual page:

"-f filter
Specify a filter for the previous event. This must come after a -e. This 
will filter what events get recorded based on the content of the event. 
Filtering is passed to the kernel directly so what filtering is allowed 
may depend on what version of the kernel you have. Basically, it will 
let you use C notation to check if an event should be processed or not.

==, >=, <=, >, <, &, |, && and ||

The above are usually safe to use to compare fields."

> Tested-by: Arend van Spriel<arend@broadcom.com>
> Signed-off-by: Steven Rostedt<rostedt@goodmis.org>

Regards,
Arend

