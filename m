Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751667AbaKIWc1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2014 17:32:27 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:19475 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751470AbaKIWc0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2014 17:32:26 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+G1GXmWYLWcK8aKwWLeoVnaYKVFzLAdxc=
X-DKIM: OpenDKIM Filter v2.0.1 titan 26759615FB5
Date: Sun, 9 Nov 2014 17:32:21 -0500
From: Jason Cooper <jason@lakedaemon.net>
To: Niklas Svensson <nks@flawful.org>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        eric.rost@mybabylon.net, gregkh@linuxfoundation.org
Subject: Re: [PATCH] staging: skein: fixed sparse warnings related to
 static declarations
Message-ID: <20141109223221.GA3698@titan.lakedaemon.net>
References: <1415461758-9587-1-git-send-email-nks@flawful.org>
 <20141108195633.GM3698@titan.lakedaemon.net>
 <545FB7B8.5080506@flawful.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <545FB7B8.5080506@flawful.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 09, 2014 at 07:51:36PM +0100, Niklas Svensson wrote:
> 
> On 11/08/2014 08:56 PM, Jason Cooper wrote:
> > On Sat, Nov 08, 2014 at 04:49:18PM +0100, Niklas Svensson wrote:
> >> drivers/staging/skein/skein_generic.c:30:5: warning: symbol 'skein256_update' was not declared. Should it be static?
> >> drivers/staging/skein/skein_generic.c:65:5: warning: symbol 'skein512_update' was not declared. Should it be static?
> >> drivers/staging/skein/skein_generic.c:100:5: warning: symbol 'skein1024_update' was not declared. Should it be static?
> >>
> >> Signed-off-by: Niklas Svensson <nks@flawful.org>
> >> ---
> >>  drivers/staging/skein/skein_generic.c | 6 +++---
> >>  1 file changed, 3 insertions(+), 3 deletions(-)
> >>
> > What tree/tag is this patch against?  There've been quite a few changes
> > to the api this time around.
> >
> linux-next,
> tag: next-20141106
> 
> also applicable for gregkg's staging-next tree

Perfect.

Acked-by: Jason Cooper <jason@lakedaemon.net>

thx,

Jason.
