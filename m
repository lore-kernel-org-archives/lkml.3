Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934596Ab3CNSQc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 14:16:32 -0400
Received: from mho-04-ewr.mailhop.org ([204.13.248.74]:13547 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933493Ab3CNSQa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 14:16:30 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 72.84.113.162
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+tOrfxtp3Yibh1S3AMc/5QIAvKDU/xi3E=
Date: Thu, 14 Mar 2013 14:16:14 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Florian Fainelli <florian@openwrt.org>
Cc: davem@davemloft.net,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Andrew Lunn <andrew@lunn.ch>, Russell King <linux@arm.linux.org.uk>,
        linux-doc@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@secretlab.ca>, netdev@vger.kernel.org,
        Paul Mackerras <paulus@samba.org>,
        linux-arm-kernel@lists.infradead.org, Rob Landley <rob@landley.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linuxppc-dev@lists.ozlabs.org,
        Lennert Buytenhek <buytenh@wantstofly.org>
Subject: Re: [PATCH 0/5] mv643xx_eth: use mvmdio MDIO bus driver
Message-ID: <20130314181614.GV12700@titan.lakedaemon.net>
References: <1359473048-26551-1-git-send-email-florian@openwrt.org>
 <20130314172544.GT12700@titan.lakedaemon.net>
 <5142124E.7050909@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <5142124E.7050909@openwrt.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 14, 2013 at 07:09:18PM +0100, Florian Fainelli wrote:
> Hello Jason,
> 
> Le 03/14/13 18:25, Jason Cooper a écrit :
> >Florian,
> >
> >Any word on version 2 of this series?  I'd like to base the conversion
> >of kirkwood to DT based ethernet init on it.
> 
> Just sent them out for review, thanks for reminder, they were
> sitting in my tree for a couple days already.

Great!  I'll give this a spin.

thx,

Jason.
