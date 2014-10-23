Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932636AbaJWMvv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 08:51:51 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:64044 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932432AbaJWMvr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 08:51:47 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18T1h2iIR0vXRQAN22vrSpF9nW6tTDwRzM=
X-DKIM: OpenDKIM Filter v2.0.1 titan 41B88606464
Date: Thu, 23 Oct 2014 08:51:41 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Eric Rost <eric.rost@mybabylon.net>, gregkh@linuxfoundation.org,
        jake@lwn.net, antonysaraev@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] staging: skein: Add Crypto API support
Message-ID: <20141023125141.GL17447@titan.lakedaemon.net>
References: <cover.1414030776.git.eric.rost@mybabylon.net>
 <e9cb9bb24d2c34a6f6d9459a22c79609ff5cb60e.1414030776.git.eric.rost@mybabylon.net>
 <20141023122845.GP23154@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141023122845.GP23154@mwanda>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 23, 2014 at 03:28:45PM +0300, Dan Carpenter wrote:
> On Wed, Oct 22, 2014 at 09:23:51PM -0500, Eric Rost wrote:
> > Adds crypto API support for the skein module. Also collapses the
> > threefish module into the skein module.
> 
> Why is this in staging anyway?  It seems very small and not terrible
> code.  It could easily be sent to the main kernel.

Yes, we're almost there.  Loadable module support and integration into
the crypto API were what was blocking my proposal to move into mainline.
It might even happen this cycle if we can get this series into -next for
a bit.

thx,

Jason.
