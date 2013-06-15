Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754069Ab3FOCbO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 22:31:14 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:17190 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751512Ab3FOCbN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 22:31:13 -0400
X-Authority-Analysis: v=2.0 cv=Odoa/2vY c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=w1cNLofYa50A:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=yqaEuN8awxIA:10 a=nVz645pjsjjJwVEGz_sA:9 a=QEXdDO2ut3YA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1371263472.9844.341.camel@gandalf.local.home>
Subject: Re: Regression in RCU subsystem in latest mainline kernel
From: Steven Rostedt <rostedt@goodmis.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Rojhalat Ibrahim <imr@rtschenk.de>, paulmck@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>
Date: Fri, 14 Jun 2013 22:31:12 -0400
In-Reply-To: <1371262867.21896.27.camel@pasglop>
References: <1626500.7WAVXjfS9F@pcimr>
	 <20130614122800.GL5146@linux.vnet.ibm.com> <1645938.As0LR1yeVd@pcimr>
	 <1371243967.9844.338.camel@gandalf.local.home>
	 <1371261741.21896.20.camel@pasglop>
	 <1371262654.9844.340.camel@gandalf.local.home>
	 <1371262867.21896.27.camel@pasglop>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-06-15 at 12:21 +1000, Benjamin Herrenschmidt wrote:
> On Fri, 2013-06-14 at 22:17 -0400, Steven Rostedt wrote:
> > On Sat, 2013-06-15 at 12:02 +1000, Benjamin Herrenschmidt wrote:
> > > On Fri, 2013-06-14 at 17:06 -0400, Steven Rostedt wrote:
> > > > I was pretty much able to reproduce this on my PA Semi PPC box. Funny
> > > > thing is, when I type on the console, it makes progress. Anyway, it
> > > > seems that powerpc has an issue with irq_work(). I'll try to get some
> > > > time either tonight or next week to figure it out.
> > > 
> > > Does this help ?
> > 
> > It did for me. Rojhalat, did this fix your issue too?
> 
> Ok, adding that to what I'm about to send to Linus.
> 

Feel free to add: Tested-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve


