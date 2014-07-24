Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758770AbaGXMMC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 08:12:02 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:49999 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756835AbaGXML7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 08:11:59 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+sNIzIb5H/+4HQTb24ffYvpBvNwwf/c9g=
X-DKIM: OpenDKIM Filter v2.0.1 titan A56185B4DC2
Date: Thu, 24 Jul 2014 08:11:37 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Andrew Lunn <andrew@lunn.ch>
Cc: Benoit Masson <yahoo@perenite.com>, benoitm@perenite.com,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        gregory.clement@free-electrons.com,
        sebastian.hesselbarth@googlemail.com
Subject: Re: [PATCH 2/2] ARM: mvebu: Added dts defintion for Lenovo Iomega
 ix4-300d NAS
Message-ID: <20140724121137.GU23220@titan.lakedaemon.net>
References: <1406155973-13657-1-git-send-email-yahoo@perenite.com>
 <20140723232715.GL23220@titan.lakedaemon.net>
 <20140723232909.GE28485@lunn.ch>
 <20140723234256.GN23220@titan.lakedaemon.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140723234256.GN23220@titan.lakedaemon.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Benoit,

> On Thu, Jul 24, 2014 at 01:29:09AM +0200, Andrew Lunn wrote:
> > 
> > We should not really leave the i2c compatibility string as it is.
> > 

If you were to apply

  ed2d859119f9 ARM: mvebu: Fix broken SoC ID detection

And then remove the -a0 i2c compatible string, does your board boot?

The referenced patch has been in mainline since v3.16-rc3, so you could
just try that kernel w/o the compatible string.

thx,

Jason.
