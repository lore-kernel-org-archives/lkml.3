Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751342AbaABKoK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 05:44:10 -0500
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:53847 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750756AbaABKoI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 05:44:08 -0500
Date: Thu, 2 Jan 2014 10:35:22 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: Gerhard Sittig <gsi@denx.de>,
        Christian Hohnstaedt <chohnstaedt@innominate.com>,
        Krzysztof =?utf-8?Q?Ha=C5=82asa?= <khalasa@piap.pl>,
        lkml <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: About Mail-Followup-To and Mutt [Was: Re: [ARM] Fix kernel
	compile error: drivers/crypto/ixp4xx_crypto.c]
Message-ID: <20140102103522.GH16456@n2100.arm.linux.org.uk>
References: <m3d2kduwd7.fsf@t19.piap.pl> <20131231134820.GS8064@book.gsilab.sittig.org> <20131231181427.GE16456@n2100.arm.linux.org.uk> <20140101121822.GA20094@book.gsilab.sittig.org> <20140102084252.GF10158@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140102084252.GF10158@pengutronix.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 02, 2014 at 09:42:52AM +0100, Uwe Kleine-König wrote:
> I have
> 
> 	# set followup_to = yes
> 
> in my .mutt/muttrc---so I'm using the default---but I'm still
> unaffected. I think this is because I don't have any lists specified
> (using the lists and subscribe commands). And note that there are lists
> that consider using MFT to be good, ISTR that it applies to
> *@lists.debian.org, but cannot currently find a reference to support
> that claim. The problem is that using MFT only works if all recipents
> are using and respecting it.

Your last statement is total rubbish.  This header is seen by the
mainstream Linux community as being totally evil.

> If Russell is annoyed in general by MFT, he could unset
> honor_followup_to.

And how does that stop the problem when someone *else* replies to the
message with a Mail-Followup-To?  FYI, I was hounded off LKML for having
that header set.

When people have this header set, and people reply to such a message, all
recipients get moved into the To: header.  This makes it impossible on
high traffic lists for people to prioritise their reading of messages
according to whether they're in the To: header or just in the Cc: header.

Being in the To: header means that someone is directing the message *AT*
you and wanting *YOU* to do something with it.  Being in the Cc: is more
"for information" and so takes a lower priority.

Hence, when someone replies to a message, and their mail client ends up
moving all recipients into the To: header, it completely destroys the
ability to prioritise the reading.  So, either we adopt the same position
here as the rest of the Linux community wrt this header, or I'm just going
to read messages on the list at random, completely ignoring whether I'm
in the To: header or not.

What that means is that there will have *no way* to attract my attention
to any email message - since I will not care one bit whether I'm listed
me in the To: header or not.

And no, you are NOT going to pester me on IRC each time.

--
FTTC broadband for 0.8mile line: 5.8Mbps down 500kbps up.  Estimation
in database were 13.1 to 19Mbit for a good line, about 7.5+ for a bad.
Estimate before purchase was "up to 13.2Mbit".
