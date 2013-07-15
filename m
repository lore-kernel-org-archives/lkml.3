Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758237Ab3GOWHc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 18:07:32 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:37575 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755132Ab3GOWHa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 18:07:30 -0400
Date: Mon, 15 Jul 2013 15:07:30 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: David Woodhouse <dwmw2@infradead.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
        ksummit-2013-discuss@lists.linuxfoundation.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [Ksummit-2013-discuss] KS Topic request: Handling the Stable
 kernel, let's dump the cc: stable tag
Message-ID: <20130715220730.GA23916@roeck-us.net>
References: <1373916476.2748.69.camel@dabdike>
 <20130715201943.GA22131@roeck-us.net>
 <1373925868.24167.35.camel@shinybook.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1373925868.24167.35.camel@shinybook.infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 15, 2013 at 11:04:28PM +0100, David Woodhouse wrote:
> On Mon, 2013-07-15 at 13:19 -0700, Guenter Roeck wrote:
> > That seems to be a bit drastic. It is quite useful to have the tag,
> > but maybe it should only be added by the maintainer and not in the initial
> > patch submission. This would ensure that the maintainer(s) made the decision.
> > If the original patch submitter thinks that the patch is stable material,
> > that information could be added in the comments section.
> 
> In the case where a maintainer applies a patch with 'git am', surely
> they can *see* that it's cc:stable?
> 
If that maintainer is careful, yes. But that isn't the point or idea. The
difference is that the maintainer would have to make an active decision
to add the cc:stable tag vs. just going along with it.

Guenter
