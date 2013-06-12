Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756901Ab3FLQSE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 12:18:04 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:62572 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752985Ab3FLQSC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 12:18:02 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 72.84.113.162
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+1oV1rXkQ4KY5c8/2cxWSf1rPYY66zWpo=
Date: Wed, 12 Jun 2013 12:17:58 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Joe Perches <joe@perches.com>
Cc: Phil Carmody <phil.carmody@partner.samsung.com>, apw@canonical.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] checkpatch: forgive use of mixed case variables
 measuring units
Message-ID: <20130612161758.GU23859@titan.lakedaemon.net>
References: <1369825370-31901-1-git-send-email-phil.carmody@partner.samsung.com>
 <1369826652.22004.106.camel@joe-AO722>
 <003601ce676c$a92360c0$fb6a2240$%carmody@partner.samsung.com>
 <1371052935.2069.14.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1371052935.2069.14.camel@joe-AO722>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 12, 2013 at 09:02:15AM -0700, Joe Perches wrote:
> On Wed, 2013-06-12 at 15:59 +0300, Phil Carmody wrote:
> > I agree that a creeping list of exceptions where CamelCase
> > is to be overlooked would be bad, but I would argue that 
> > perhaps my exceptions aren't actual CamelCase - they're
> > (pretending to be) SI units, and just happen to match the
> > CamelCase regexp. I did a grep for my regexp, and everything
> > I noticed in a quick scan did look like a justifiable 
> > variable name.
> 
> Maybe, but this regex misses variants like:
> 
> regulator_min_uA_show
> 
> Maybe "^[a-z_]*_[numk][VAS](?:_\w+)?$"
> 
> But this regex also does not match on other common
> sound variants "_dB", "_mB" and temperature like "_mC".

And _dBm ...

thx,

Jason.
