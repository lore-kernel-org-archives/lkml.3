Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756363Ab3HFUL6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 16:11:58 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:28271 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756004Ab3HFUL5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 16:11:57 -0400
X-Authority-Analysis: v=2.0 cv=aqMw+FlV c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=o9wxAiQGZFUA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=lPGdCojwBkAA:10 a=ILKQN-IaDvy-FbjecFYA:9 a=QEXdDO2ut3YA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-ID: <1375819915.25420.49.camel@gandalf.local.home>
Subject: Re: x86: use this_cpu for debug_stack_usage
From: Steven Rostedt <rostedt@goodmis.org>
To: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: Christoph Lameter <cl@gentwo.org>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>
Date: Tue, 06 Aug 2013 16:11:55 -0400
In-Reply-To: <52015796.3010007@linux.intel.com>
References: <000001405493dacb-4d662921-2531-400a-a426-4f76c8066ede-000000@email.amazonses.com>
	  <1375811455.25420.39.camel@gandalf.local.home>
	  <0000014054fd1db5-e6fbcc32-2e6c-49b1-83d4-399791ee6829-000000@email.amazonses.com>
	 <1375815765.25420.45.camel@gandalf.local.home>
	 <52015796.3010007@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-08-06 at 13:07 -0700, H. Peter Anvin wrote:
> On 08/06/2013 12:02 PM, Steven Rostedt wrote:
> > On Tue, 2013-08-06 at 18:56 +0000, Christoph Lameter wrote:
> >>> Might as well change is_debug_stack() to use __this_cpu_read() instead
> >>> of __get_cpu_var().
> > 
> > I just noticed that you didn't include the x86 maintainers.
> > 
> > Reviewed-by: Steven Rostedt <rostedt@goodmis.org>
> > 
> 
> Looks good to me.
> 
> Do you want an ACK from me or do you want me to pick it up?
> 

You can take it.

Thanks,

-- Steve


