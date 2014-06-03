Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754017AbaFCIJI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 04:09:08 -0400
Received: from vps0.lunn.ch ([178.209.37.122]:54976 "EHLO vps0.lunn.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753948AbaFCIJB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 04:09:01 -0400
Date: Tue, 3 Jun 2014 10:05:22 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Antoine =?iso-8859-1?Q?T=E9nart?= 
	<antoine.tenart@free-electrons.com>
Cc: sebastian.hesselbarth@gmail.com, thomas.petazzoni@free-electrons.com,
        zmxu@marvell.com, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, alexandre.belloni@free-electrons.com,
        jszhang@marvell.com, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 2/2] ARM: dts: berlin: enable i2c0 and i2c2
Message-ID: <20140603080522.GB22742@lunn.ch>
References: <1401780790-17830-1-git-send-email-antoine.tenart@free-electrons.com>
 <1401780790-17830-3-git-send-email-antoine.tenart@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1401780790-17830-3-git-send-email-antoine.tenart@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 03, 2014 at 09:33:10AM +0200, Antoine Ténart wrote:
> Enable the I2C0 and I2C2 for the Marvell Berlin BG2G DMP. I2C1 and I2C3
> are also working on this board, but no devices seemed to be there.

Hi Antoine

Does this mean that IC0 and I2C2 have devices on them? Could you also
add nodes for the devices?

    Andrew
