Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751749AbaBXCJ0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Feb 2014 21:09:26 -0500
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:58607 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751310AbaBXCJY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Feb 2014 21:09:24 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApcDAP6oClOl5H4JgWdsb2JhbABZwXSDB4EkDgEBFiYogiUBAQQBJxM/EAsYCRUQDwFHBogQCMZOF45kB4Q4BKxKgVIo
From: Alistair Popple <alistair@popple.id.au>
To: Mark Rutland <mark.rutland@arm.com>
Cc: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 2/7] IBM Akebono: Add support for a new PHY interface to the IBM emac driver
Date: Mon, 24 Feb 2014 13:09:19 +1100
Message-ID: <7545458.ltLKFumBkZ@mexican>
User-Agent: KMail/4.9.5 (Linux/3.5.0-45-generic; KDE/4.9.5; x86_64; ; )
In-Reply-To: <20140221111823.GA8783@e106331-lin.cambridge.arm.com>
References: <1392964293-13687-1-git-send-email-alistair@popple.id.au> <1392964293-13687-3-git-send-email-alistair@popple.id.au> <20140221111823.GA8783@e106331-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Feb 2014 11:18:23 Mark Rutland wrote:
> On Fri, Feb 21, 2014 at 06:31:28AM +0000, Alistair Popple wrote:

[...]

> 
> > +       /* Check for RGMII flags */
> > +       if (of_get_property(ofdev->dev.of_node, "has-mdio", NULL))
> > +               dev->flags |= EMAC_RGMII_FLAG_HAS_MDIO;
> 
> You can use of_property_read_bool here.

Thanks. I will update it.

Regards,

Alistair

> 
> Cheers,
> Mark.
