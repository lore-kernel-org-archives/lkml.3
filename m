Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752518AbaEWNjj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 09:39:39 -0400
Received: from vps0.lunn.ch ([178.209.37.122]:50737 "EHLO vps0.lunn.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751313AbaEWNjh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 09:39:37 -0400
Date: Fri, 23 May 2014 15:36:08 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Andrew Lunn <andrew@lunn.ch>
Cc: Kishon Vijay Abraham I <kishon@ti.com>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Mathias Nyman <mathias.nyman@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jason Cooper <jason@lakedaemon.net>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, Lior Amsalem <alior@marvell.com>,
        Tawfik Bayouk <tawfik@marvell.com>, Nadav Haklai <nadavh@marvell.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org
Subject: Re: [PATCH 2/5] Documentation: dt-bindings: document the Armada 375
 USB cluster binding
Message-ID: <20140523133608.GB31314@lunn.ch>
References: <1400257376-13251-1-git-send-email-gregory.clement@free-electrons.com>
 <1400257376-13251-2-git-send-email-gregory.clement@free-electrons.com>
 <537F13B2.6070500@ti.com>
 <20140523132145.GA31314@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140523132145.GA31314@lunn.ch>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Do you want one .txt file per driver, or can we combine binding
> documentations into one file? There should already be a mvebu-phy.txt,
> which contains the sata phy usable on some of the Armada SoC families.
> This binding could be appended to it.

Ah. Humm, well! It seems the patch adding the mvebu-phy.txt fell
through a crack when adding the driver.

Kishon could you take
http://www.spinics.net/lists/devicetree/msg17018.html into your tree?
It should of been taken the same time you took the actual driver,
http://www.spinics.net/lists/devicetree/msg17011.html into your tree.

I can resend that one missing patch if you want.

  Andrew
