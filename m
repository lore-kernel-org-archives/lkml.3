Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933237Ab3CHLiG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 06:38:06 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:25995 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752330Ab3CHLiD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 06:38:03 -0500
X-Authority-Analysis: v=2.0 cv=UN5f7Vjy c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=YMeCJBTquIIA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=RijN4k9VLrAA:10 a=cCcTGBnLAAAA:8 a=4Ruuc49OSHJ3bpq9Z9YA:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1362742682.31874.91.camel@gandalf.local.home>
Subject: Re: [PATCH] init: Scream bloody murder if interrupts are enabled
 too early
From: Steven Rostedt <rostedt@goodmis.org>
To: Ard van Breemen <ard@telegraafnet.nl>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Fri, 08 Mar 2013 06:38:02 -0500
In-Reply-To: <20130308090300.GM1585@telegraafnet.nl>
References: <1362694743.31874.66.camel@gandalf.local.home>
	 <20130308090300.GM1585@telegraafnet.nl>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-03-08 at 10:03 +0100, Ard van Breemen wrote:

> The original code was a few versions before the WARN macros.
> I think it's better to just change the printk to something like:
> WARN(1,"interrupts were enabled *very* early, fixing it\n")
> 

Yeah, I thought about updating to that, but I was lazy. I was hoping
nobody would notice. ;-)

OK, I'll send out -v2 as soon as I finish testing it.

Thanks,

-- Steve


