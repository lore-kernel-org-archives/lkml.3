Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752834AbaABSdQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 13:33:16 -0500
Received: from mail.skyhub.de ([78.46.96.112]:39004 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752294AbaABSdN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 13:33:13 -0500
Date: Thu, 2 Jan 2014 19:33:11 +0100
From: Borislav Petkov <bp@alien8.de>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Gerhard Sittig <gsi@denx.de>,
        Christian Hohnstaedt <chohnstaedt@innominate.com>,
        Krzysztof =?utf-8?Q?Ha=C5=82asa?= <khalasa@piap.pl>,
        lkml <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: About Mail-Followup-To and Mutt [Was: Re: [ARM] Fix kernel
 compile error: drivers/crypto/ixp4xx_crypto.c]
Message-ID: <20140102183311.GC8772@nazgul.tnic>
References: <m3d2kduwd7.fsf@t19.piap.pl>
 <20131231134820.GS8064@book.gsilab.sittig.org>
 <20131231181427.GE16456@n2100.arm.linux.org.uk>
 <20140101121822.GA20094@book.gsilab.sittig.org>
 <20140102084252.GF10158@pengutronix.de>
 <20140102103522.GH16456@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140102103522.GH16456@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 02, 2014 at 10:35:22AM +0000, Russell King - ARM Linux wrote:
> And how does that stop the problem when someone *else* replies to the
> message with a Mail-Followup-To?  FYI, I was hounded off LKML for having
> that header set.
> 
> When people have this header set, and people reply to such a message, all
> recipients get moved into the To: header.  This makes it impossible on
> high traffic lists for people to prioritise their reading of messages
> according to whether they're in the To: header or just in the Cc: header.
> 
> Being in the To: header means that someone is directing the message *AT*
> you and wanting *YOU* to do something with it.  Being in the Cc: is more
> "for information" and so takes a lower priority.

Totally agreed.

That MFT thing might've been a good idea at the time but in reality
it causes more problems than it solves, with our usage patterns. I've
started ignoring it and would suggest people simply drop all those
"lists/subsribe" directives in their .muttrc.

Thanks.
