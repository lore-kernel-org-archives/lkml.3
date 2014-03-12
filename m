Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752841AbaCLMjX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 08:39:23 -0400
Received: from vps0.lunn.ch ([178.209.37.122]:41851 "EHLO vps0.lunn.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752616AbaCLMjS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 08:39:18 -0400
Date: Wed, 12 Mar 2014 13:37:59 +0100
From: Andrew Lunn <andrew@lunn.ch>
To: Jisheng Zhang <jszhang@marvell.com>
Cc: Antoine =?iso-8859-1?Q?T=E9nart?= 
	<antoine.tenart@free-electrons.com>,
        "sebastian.hesselbarth@gmail.com" <sebastian.hesselbarth@gmail.com>,
        Jimmy Xu <zmxu@marvell.com>,
        "alexandre.belloni@free-electrons.com" 
	<alexandre.belloni@free-electrons.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 2/2] ARM: dts: berlin2q: add the Marvell BG2-Q DMP device
 tree
Message-ID: <20140312123759.GB15090@lunn.ch>
References: <1394622364-6848-1-git-send-email-antoine.tenart@free-electrons.com>
 <1394622364-6848-3-git-send-email-antoine.tenart@free-electrons.com>
 <20140312200428.23178d69@xhacker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140312200428.23178d69@xhacker>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > +/dts-v1/;
> > +#include "berlin2q.dtsi"
> > +
> > +/ {
> > +	model = "Marvell BG2-Q DMP";
> > +	compatible = "marvell,berlin2q-dmp", "marvell,berlin2q",
> > "marvell,berlin"; +
> > +	memory {
> > +		device_type = "memory";
> > +		reg = <0x00000000 0x40000000>;
> 
> The memory size of BG2Q DMP is 2GB.

Jisheng

Does this imply that the RAM is inside the SoC package, and that
there is no external memory interface which can be used to add more
RAM?

	Thanks
		Andrew
