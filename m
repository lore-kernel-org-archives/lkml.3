Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758710Ab3GPDnN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 23:43:13 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:4378 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755335Ab3GPDnL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 23:43:11 -0400
X-Authority-Analysis: v=2.0 cv=Tr1kdUrh c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=pKJnpFkXxSEA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=H1u3HIS9vXkA:10 a=dHC3jRT_i2HfWTKPtbUA:9 a=QEXdDO2ut3YA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-ID: <1373946189.17876.267.camel@gandalf.local.home>
Subject: Re: [Ksummit-2013-discuss] KS Topic request: Handling the Stable
 kernel, let's dump the cc: stable tag
From: Steven Rostedt <rostedt@goodmis.org>
To: Dave Airlie <airlied@gmail.com>
Cc: Ben Hutchings <ben@decadent.org.uk>, Greg KH <greg@kroah.com>,
        ksummit-2013-discuss@lists.linuxfoundation.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Date: Mon, 15 Jul 2013 23:43:09 -0400
In-Reply-To: <CAPM=9twPxz60WObwG5SuCxFrGTr7KzQyS3iqGnF8MQJPUZuHOg@mail.gmail.com>
References: <1373916476.2748.69.camel@dabdike>
	 <20130715214422.GA2478@kroah.com>
	 <1373925699.17876.218.camel@gandalf.local.home>
	 <20130716000623.GB26261@kroah.com>
	 <1373940594.17876.241.camel@gandalf.local.home>
	 <1373942486.31067.122.camel@deadeye.wl.decadent.org.uk>
	 <CAPM=9twPxz60WObwG5SuCxFrGTr7KzQyS3iqGnF8MQJPUZuHOg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-07-16 at 13:27 +1000, Dave Airlie wrote:

> > I also heard some managers decided their kernel source packages should
> > have all the patches squashed together to make them harder to cherry-
> > pick... could it have been the same company?
> 
> Greg loves to tell stories about RH management, but really if he can
> find any engineer who works for RH that says he can't work on stable
> due to being told by management, I'd be surprised. Maybe when stable
> first surfaced there was a hope of it being close to RHEL, but at this
> point stable has little to no usefulness from a RHEL point of view,
> and since nearly all the RH employed maintainers all do stable work, I
> can't see why Greg would think this matters.

And to stress that point. I myself work for Red Hat, and I'm very big
into the stable tree. Heck, I maintain a 3.6 stable (not as well as
"Greg" does, but I'm just a mere mortal).

I don't know what managers Greg talked to, but I've been encouraged by
management to mark bug fixes with the stable tag.

-- Steve


