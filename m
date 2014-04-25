Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752455AbaDYQCH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 12:02:07 -0400
Received: from vps0.lunn.ch ([178.209.37.122]:33296 "EHLO vps0.lunn.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751293AbaDYQCD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 12:02:03 -0400
Date: Fri, 25 Apr 2014 17:59:23 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
Cc: Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Mathias Nyman <mathias.nyman@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Felipe Balbi <balbi@ti.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, Lior Amsalem <alior@marvell.com>,
        Tawfik Bayouk <tawfik@marvell.com>, Nadav Haklai <nadavh@marvell.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org
Subject: Re: [PATCH v2 14/18] ARM: mvebu: Add support for USB cluster on the
 Armada 375 SoC
Message-ID: <20140425155923.GD12472@lunn.ch>
References: <1398434836-18908-1-git-send-email-gregory.clement@free-electrons.com>
 <1398434836-18908-15-git-send-email-gregory.clement@free-electrons.com>
 <20140425154320.GA20801@arch.cereza>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140425154320.GA20801@arch.cereza>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > +			 * We can't use usb2 and usb3 in the same time, so let's
> > +			 * disbale usb2 and complain about it to the user askinf
> 
> typos: disable, asking

And it should be "at the same time", not in.

    Andrew
