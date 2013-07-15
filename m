Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757113Ab3GOVH2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 17:07:28 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:23019 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755228Ab3GOVH1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 17:07:27 -0400
X-Authority-Analysis: v=2.0 cv=Odoa/2vY c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=pKJnpFkXxSEA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=H1u3HIS9vXkA:10 a=fRFf-9U95T6W5Gb650oA:9 a=QEXdDO2ut3YA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-ID: <1373922445.17876.204.camel@gandalf.local.home>
Subject: Re: [Ksummit-2013-discuss] KS Topic request: Handling the Stable
 kernel, let's dump the cc: stable tag
From: Steven Rostedt <rostedt@goodmis.org>
To: Mark Brown <broonie@kernel.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
        ksummit-2013-discuss@lists.linuxfoundation.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Date: Mon, 15 Jul 2013 17:07:25 -0400
In-Reply-To: <20130715201538.GE11538@sirena.org.uk>
References: <1373917517.17876.193.camel@gandalf.local.home>
	 <20130715201538.GE11538@sirena.org.uk>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-07-15 at 21:15 +0100, Mark Brown wrote:

> One thing I don't particularly like about this is having to resend the
> patches in response to mail; it seems cumbersome to do that rather than
> reply to mail or something.  Requiring a positive acknowledgement or
> action seems useful but the particular one seems a bit annoying; I'd
> rather either just send the patch as part of the mark for stable
> workflow or ack something in mail.

A reply to the email before it goes in would work as well. I'm just
saying that the stable tag alone should not be the criteria of what goes
into stable.

> 
> > Also, we could mandate that the maintainers do the backports too.
> 
> That's what happens already isn't it?

Only if it breaks. But I've been quite impressed at a lot of the patches
that Greg seems to get working himself. He gets things backported that
don't look to be automated. I guess if it's trivial enough he does the
work himself. But I've had a few commits where I thought for sure I
would get a slew of "FAILED to apply" stable messages that ended up
going in without my help.

-- Steve


