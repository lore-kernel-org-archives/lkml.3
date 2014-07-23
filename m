Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758348AbaGWXPz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 19:15:55 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:56816 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753341AbaGWXPx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 19:15:53 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX182nWcZiL09hfxZbOIhq52/dLv4iUz7CGA=
X-DKIM: OpenDKIM Filter v2.0.1 titan DDBC75B4502
Date: Wed, 23 Jul 2014 19:15:35 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Benoit Masson <benoitm@perenite.com>
Cc: Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Benoit Masson <yahoo@perenite.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Sebastian Hesselbarth <sebastian.hesselbarth@googlemail.com>
Subject: Re: [PATCH 2/2] ARM: mvebu: Added dts defintion for Lenovo Iomega
 ix4-300d NAS
Message-ID: <20140723231535.GK23220@titan.lakedaemon.net>
References: <1406154923-13612-1-git-send-email-yahoo@perenite.com>
 <1406154923-13612-2-git-send-email-yahoo@perenite.com>
 <20140723224236.GC28485@lunn.ch>
 <94F87063-D717-435B-B7C5-EDAC9B26742C@perenite.com>
 <20140723225841.GD28485@lunn.ch>
 <10A7C530-7CD2-4ED0-889A-7FAC1922320F@perenite.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <10A7C530-7CD2-4ED0-889A-7FAC1922320F@perenite.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 24, 2014 at 01:11:12AM +0200, Benoit Masson wrote:
> Le 24 juil. 2014 à 00:58, Andrew Lunn <andrew@lunn.ch> a écrit :
> 
> >> For the marvell,mv78230-a0-i2c unfortunately i've spend 3 hours
> >> trying to understand this but it only works with this on the
> >> ix4-300d :(. There was multiple patch around this and maybe one
> >> broke the auto-detect part of this, I've tried compiling with some
> >> 3.10 or lower kernel but no luck here I still have to put this a0
> >> option.
> > 
> > Lets first confirm you have an a0 SoC.
> > 
> > At boot time, it should print:
> > 
> > pr_info("MVEBU SoC ID=0x%X, Rev=0x%X\n", soc_dev_id, soc_rev);
> > 
> > What revision do you have?
> > 
> > If the auto detect code really is broken, Gregory will likely take a
> > look.
> 
> I sure do,
> 
> confirmed by u-boot  output below:
> 
> U-Boot 2009.08 (Mar 04 2013 - 11:13:04) Marvell version:  2.3.2 PQ
> U-Boot Addressing:
>        Code:..00600000:006BFFF0
>        BSS:..00708EC0
>        Stack:..0x5fff70
>        PageTable:.0x8e0000
>        Heap address:.0x900000:0xe00000
> Board: DB-78230-BP rev 2.0 Wistron
> SoC:   MV78230 A0
> 
> From kernel I get:
> 
> mvebu-soc-id: MVEBU SoC ID=0x7823, Rev=0x1

Well, isn't that a peach?  :)  Gregory?

thx,

Jason.

