Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757549Ab3GOVVZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 17:21:25 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:18468 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755288Ab3GOVVX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 17:21:23 -0400
X-Authority-Analysis: v=2.0 cv=Du3UCRD+ c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=pKJnpFkXxSEA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=H1u3HIS9vXkA:10 a=W1DfZqIjhQdKwywdqKoA:9 a=QEXdDO2ut3YA:10 a=TAHrYieMPH2WeErh:21 a=n6_q-RSoi1XPG-16:21 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-ID: <1373923281.17876.208.camel@gandalf.local.home>
Subject: Re: [Ksummit-2013-discuss] KS Topic request: Handling the Stable
 kernel, let's dump the cc: stable tag
From: Steven Rostedt <rostedt@goodmis.org>
To: Joe Perches <joe@perches.com>
Cc: Willy Tarreau <w@1wt.eu>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        ksummit-2013-discuss@lists.linuxfoundation.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Date: Mon, 15 Jul 2013 17:21:21 -0400
In-Reply-To: <1373922593.2062.36.camel@joe-AO722>
References: <1373916476.2748.69.camel@dabdike>
	 <1373917517.17876.193.camel@gandalf.local.home>
	 <20130715195505.GE10157@1wt.eu>
	 <1373921779.17876.200.camel@gandalf.local.home>
	 <1373922593.2062.36.camel@joe-AO722>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-07-15 at 14:09 -0700, Joe Perches wrote:
> On Mon, 2013-07-15 at 16:56 -0400, Steven Rostedt wrote:
> > It may not be efficient for maintainers, but as maintainers we should
> > spend a bit more time on stable releases.
> 
> The MAINTAINERS file specifies a difference between a
> section that's Maintained vs Supported.

I never noticed this before. Hmm, Red Hat pays me to work on real-time,
but lets me also work on ftrace. I wounder if I should switch that to
"Supported", although I push tracing support behind having to do
real-time, as that's really my job.

> 
> Do please remember there's a difference between a maintainer
> and someone that's paid to support a particular thing.
> 
> My feeling is if you're a maintainer you can just say
> "use the current version" and not spend even a moments
> effort or thought on backports.

If you're doing this as a volunteer, then you have every right to say
such a thing. But I have to ask. How many maintainers are really just
volunteers? And of those, how many have critical parts of the kernel
that distros rely on. If they do, then one would think that a distro
would hire them.

> 
> When you're getting paid however, different issues...
> 

Yep.

-- Steve


