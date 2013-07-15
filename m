Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756494Ab3GOU4Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 16:56:24 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:24569 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753484Ab3GOU4W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 16:56:22 -0400
X-Authority-Analysis: v=2.0 cv=KtrPKBqN c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=pKJnpFkXxSEA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=H1u3HIS9vXkA:10 a=hPziqNZdqRgauE9_49EA:9 a=QEXdDO2ut3YA:10 a=TKhISKaq-GciQIia:21 a=W3n_ryjc_6tgCb02:21 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-ID: <1373921779.17876.200.camel@gandalf.local.home>
Subject: Re: [Ksummit-2013-discuss] KS Topic request: Handling the Stable
 kernel, let's dump the cc: stable tag
From: Steven Rostedt <rostedt@goodmis.org>
To: Willy Tarreau <w@1wt.eu>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
        ksummit-2013-discuss@lists.linuxfoundation.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Date: Mon, 15 Jul 2013 16:56:19 -0400
In-Reply-To: <20130715195505.GE10157@1wt.eu>
References: <1373916476.2748.69.camel@dabdike>
	 <1373917517.17876.193.camel@gandalf.local.home>
	 <20130715195505.GE10157@1wt.eu>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-07-15 at 21:55 +0200, Willy Tarreau wrote:

> I disagree with your proposal. All these points are already covered by
> the stable review and the early notification that the greg-bot does when
> the patch is included in the queue. If submitters/maintainers do not read
> these e-mails sent to them about changes going to happen in the subsystems
> they're responsible for, having them resend the patches will only punish
> the honnest ones. The other ones will simply reply without doing anything
> else. In the end, we get more work to get fixes merged so less efficiency.
> 
> I tend to think the merge should be slightly less automatic or at least
> add some delay (post release for late submissions), but what I'm worried
> about is that adding exceptions to the workflow will mean more work for
> Greg, so we should be careful about this, as we have a single one and we
> don't want to burn him out.
> 

I'm temporarily maintaining a 3.6 stable release (can't wait till I
don't have to do that anymore). And I cheat. I use the trees that Greg
uses, and I still spend days getting it ready.

I think the current method does not scale. It's only been doing so well
only because Greg has been putting a lot of time and effort into it. But
I still think the process is broken.

Do I think this will add more work to the maintainer? Yes, definitely!
But we have hundreds of maintainers, and only one Greg. Where do you
think we should be adding the work too?

In another KS topic, we talked about backup maintainers. This could be
the job of #2.

Yes, there's already a automatic response, but who really looks a those.
I know I'm guilty of seeing that and saying to myself "oh good, Greg
added that patch" and not actually review it. This process may force me
to look at it better.

It may not be efficient for maintainers, but as maintainers we should
spend a bit more time on stable releases. If you do that up front before
marking commits with the stable tag, then just setup a mail filter that
simply forwards the email to the second address that Greg will take. If
you abuse that, then Greg can get nasty with you ;-)

-- Steve


