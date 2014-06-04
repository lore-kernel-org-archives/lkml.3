Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752764AbaFDRIA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 13:08:00 -0400
Received: from vps0.lunn.ch ([178.209.37.122]:55643 "EHLO vps0.lunn.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752198AbaFDRHW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 13:07:22 -0400
Date: Wed, 4 Jun 2014 19:03:40 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Antoine =?iso-8859-1?Q?T=E9nart?= 
	<antoine.tenart@free-electrons.com>
Cc: Andrew Lunn <andrew@lunn.ch>, sebastian.hesselbarth@gmail.com,
        thomas.petazzoni@free-electrons.com, zmxu@marvell.com,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        alexandre.belloni@free-electrons.com, jszhang@marvell.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 2/2] ARM: dts: berlin: enable i2c0 and i2c2
Message-ID: <20140604170340.GI6892@lunn.ch>
References: <1401780790-17830-1-git-send-email-antoine.tenart@free-electrons.com>
 <1401780790-17830-3-git-send-email-antoine.tenart@free-electrons.com>
 <20140603080522.GB22742@lunn.ch>
 <20140604164841.GA12859@kwain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140604164841.GA12859@kwain>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 04, 2014 at 06:48:41PM +0200, Antoine Ténart wrote:
> Hi Andrew,
> 
> On Tue, Jun 03, 2014 at 10:05:22AM +0200, Andrew Lunn wrote:
> > On Tue, Jun 03, 2014 at 09:33:10AM +0200, Antoine Ténart wrote:
> > > Enable the I2C0 and I2C2 for the Marvell Berlin BG2G DMP. I2C1 and I2C3
> > > are also working on this board, but no devices seemed to be there.
> > 
> > Does this mean that IC0 and I2C2 have devices on them? Could you also
> > add nodes for the devices?
> 
> No devices I can add for now. I you prefer we can drop this patch, keep
> the other one and enable i2c nodes for the BG2Q DMP when they will be
> needed.

Hi Antoine

I was just wondering how you tested it, without having any devices?
Is it that the devices on the bus don't have mainline drivers?

I don't see a reason not to commit both. At least it allows i2c-detect
to work and see what is on the bus, even if we cannot drive them.

Thanks
	Andrew
