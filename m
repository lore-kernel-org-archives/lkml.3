Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751304AbaABInI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 03:43:08 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:58724 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750711AbaABInG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 03:43:06 -0500
Date: Thu, 2 Jan 2014 09:42:52 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Gerhard Sittig <gsi@denx.de>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Christian Hohnstaedt <chohnstaedt@innominate.com>,
        Krzysztof =?utf-8?Q?Ha=C5=82asa?= <khalasa@piap.pl>,
        lkml <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: About Mail-Followup-To and Mutt [Was: Re: [ARM] Fix kernel
 compile error: drivers/crypto/ixp4xx_crypto.c]
Message-ID: <20140102084252.GF10158@pengutronix.de>
References: <m3d2kduwd7.fsf@t19.piap.pl>
 <20131231134820.GS8064@book.gsilab.sittig.org>
 <20131231181427.GE16456@n2100.arm.linux.org.uk>
 <20140101121822.GA20094@book.gsilab.sittig.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140101121822.GA20094@book.gsilab.sittig.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 01, 2014 at 01:18:22PM +0100, Gerhard Sittig wrote:
> On Tue, Dec 31, 2013 at 18:14 +0000, Russell King - ARM Linux wrote:
> > 
> > Please get rid of your Mail-Followup-To: header:
> > 
> > Mail-Followup-To: Krzysztof Hałasa <khalasa@piap.pl>,                           
> >         lkml <linux-kernel@vger.kernel.org>,                                    
> >         linux-arm-kernel@lists.infradead.org,                                   
> >         Russell King <rmk+kernel@arm.linux.org.uk>,                             
> >         Christian Hohnstaedt <chohnstaedt@innominate.com>,                      
> >         Herbert Xu <herbert@gondor.apana.org.au>                                
> > User-Agent: Mutt/1.5.21 (2010-09-15)                                            
> > 
> > It causes all recipients following the thread to be moved into the To:
> > header when someone replies to one of your messages, which is deemed to
> > be anti-social.  You can kill this header by adding:
> > 
> > 	set followup_to=no
> > 
> > to your .muttrc file.
> 
> Thank you for telling me, I was not aware.  Had no MFT related
> setting in my config, learned from the manual that $followup_to
> defaults to yes, have turned it off now.  Other mutt users may
> want to check as well.  Happy new year! :)
I have

	# set followup_to = yes

in my .mutt/muttrc---so I'm using the default---but I'm still
unaffected. I think this is because I don't have any lists specified
(using the lists and subscribe commands). And note that there are lists
that consider using MFT to be good, ISTR that it applies to
*@lists.debian.org, but cannot currently find a reference to support
that claim. The problem is that using MFT only works if all recipents
are using and respecting it.

If Russell is annoyed in general by MFT, he could unset
honor_followup_to.
 
Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
