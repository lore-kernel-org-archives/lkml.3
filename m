Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751462Ab3G2SrK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 14:47:10 -0400
Received: from vps0.lunn.ch ([178.209.37.122]:38814 "EHLO vps0.lunn.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750882Ab3G2SrI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 14:47:08 -0400
Date: Mon, 29 Jul 2013 20:45:20 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Russell King <linux@arm.linux.org.uk>, Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] ARM: dove: add initial DT file for Globalscale D2Plug
Message-ID: <20130729184520.GI24782@lunn.ch>
References: <1375100946-28521-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <1375100946-28521-5-git-send-email-sebastian.hesselbarth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375100946-28521-5-git-send-email-sebastian.hesselbarth@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 29, 2013 at 02:29:06PM +0200, Sebastian Hesselbarth wrote:
> This adds an initial DT file for the Globalscale D2Plug with Dove SoC.
> Currently, one LED is missing and I have not been able to get SD8787 driver
> working. Those will be taken care of later.

Hi Sebastion

I took a hard look at SDIO and failed to get it working when doing
DMA. Polled IO does however work. I guess we need some help from
Marvell engineers before we get stable SDIO with DMA.

	Andrew
