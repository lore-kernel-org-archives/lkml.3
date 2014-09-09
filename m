Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755204AbaIICwd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 22:52:33 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:31018 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752938AbaIICwc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 22:52:32 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 99.127.230.128
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19uLtWw0panYDjNAu6Om+vb
Date: Mon, 8 Sep 2014 19:52:26 -0700
From: Tony Lindgren <tony@atomide.com>
To: Suman Anna <s-anna@ti.com>
Cc: Jassi Brar <jaswinder.singh@linaro.org>, Dave Gerlach <d-gerlach@ti.com>,
        Markus Mayer <markus.mayer@linaro.org>, Pavel Machek <pavel@ucw.cz>,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCHv3 0/5] OMAP Mailbox framework adoption & DT support
Message-ID: <20140909025225.GI10785@atomide.com>
References: <1406680479-18446-1-git-send-email-s-anna@ti.com>
 <20140908232053.GS3238@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140908232053.GS3238@atomide.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Tony Lindgren <tony@atomide.com> [140908 16:21]:
> * Suman Anna <s-anna@ti.com> [140729 17:37]:
> > Hi,
> > 
> > This is an updated version of the OMAP Mailbox framework adoption &
> > DT support series, refreshed to work with the v9 version of the mailbox
> > framework [1] from Jassi Brar while also addressing some minor review
> > comments. Detailed changes are summarized below. Patches are based on
> > 3.16-rc2.
> 
> Sorry for the delay, just noticed that I'm supposed to queue
> these too. I'll queue these into omap-for-v3.18/mailbox against
> v3.17-rc1 and will probably also merge it into omap-for-v3.18/dt
> as well.

Actually this is not compiling and seems to probably miss
the dependencies from Jassi, so dropping the branch.

Anyways, since it seems you need to repost this again, please
repost the DT changes separately from the driver changes.

Regards,

Tony
