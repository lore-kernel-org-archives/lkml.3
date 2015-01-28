Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753770AbbA2BQq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 20:16:46 -0500
Received: from utopia.booyaka.com ([74.50.51.50]:58731 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753745AbbA2BQo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 20:16:44 -0500
Date: Wed, 28 Jan 2015 21:12:42 +0000 (UTC)
From: Paul Walmsley <paul@pwsan.com>
To: Paul Bolle <pebolle@tiscali.nl>
cc: Valentin Rothberg <valentinrothberg@gmail.com>,
        Thierry Reding <treding@nvidia.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: arm64: USB_ARCH_HAS_EHCI
In-Reply-To: <1422478839.3621.34.camel@x220>
Message-ID: <alpine.DEB.2.02.1501282106540.19947@utopia.booyaka.com>
References: <1422351833.14015.20.camel@x220>   <alpine.DEB.2.02.1501272130470.19947@utopia.booyaka.com>  <1422438405.5666.16.camel@x220>  <alpine.DEB.2.02.1501281621330.19947@utopia.booyaka.com> <1422478839.3621.34.camel@x220>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

On Wed, 28 Jan 2015, Paul Bolle wrote:

> On Wed, 2015-01-28 at 16:25 +0000, Paul Walmsley wrote:
> > Is the Kconfig checker script you mentioned on Tuesday available in the 
> > mainline tree?  I don't see anything obvious under the "Static Analysers" 
> > section of the Makefile, but perhaps I'm overlooking it.
> 
> No, it's not.
> 
> In tree you'll find scripts/checkkconfigsymbols.py. That catches over
> 90% of the stuff my local script catches, in less than 10% of runtime.
> It would certainly have caught your use of USB_ARCH_HAS_EHCI.

OK great, I'll add that to my static analysis scripts.

> My local script is my third (or fourth) attempt at a script that checks
> these kind of issues. I've used it on linux-next since for about 3/4 of
> a year now. While doing that I ran into people that are planning into
> adding similar, but far more advanced, functionality into one of the
> bots that is checking linux. So I never bothered making my script
> public. (I'm not sure what the status of those plan is now.)
> 
> In the mean time I'll keep on checking linux-next with my script. That
> should also help to see what problems an actual bot could run into, for
> the benefit of those people. 

That sounds good; it's a very useful service you're providing.

> Problems like:
> - should it check each commit (I think it should only check releases);
> - should it be a true bot (I think it needs a wetware frontend to
>   filter out non-issues).
> 
> Hope this answers your question.

It does.  Thanks for the detailed response.


- Paul
