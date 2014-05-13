Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933039AbaEMMH6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 08:07:58 -0400
Received: from top.free-electrons.com ([176.31.233.9]:38478 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759800AbaEMMHz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 08:07:55 -0400
Date: Tue, 13 May 2014 14:07:51 +0200
From: Antoine =?iso-8859-1?Q?T=E9nart?= 
	<antoine.tenart@free-electrons.com>
To: Andrew Lunn <andrew@lunn.ch>
Cc: Antoine =?iso-8859-1?Q?T=E9nart?= 
	<antoine.tenart@free-electrons.com>,
        sebastian.hesselbarth@gmail.com, tj@kernel.org,
        thomas.petazzoni@free-electrons.com, zmxu@marvell.com,
        linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
        alexandre.belloni@free-electrons.com, jszhang@marvell.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 3/6] ata: ahci: add AHCI support for the Berlin BG2Q
Message-ID: <20140513120751.GA3213@kwain>
References: <1399886217-20474-1-git-send-email-antoine.tenart@free-electrons.com>
 <1399886217-20474-4-git-send-email-antoine.tenart@free-electrons.com>
 <20140512141221.GE3378@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140512141221.GE3378@lunn.ch>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

On Mon, May 12, 2014 at 04:12:21PM +0200, Andrew Lunn wrote:
> On Mon, May 12, 2014 at 11:16:54AM +0200, Antoine Ténart wrote:

[…]

> I've no idea is this is a good or bad idea, but could you put all the
> above code in the phy driver? It does seem to be mostly phy
> related. Then teach the core ahci code about optional phy nodes in DT.
> You can then probably do without a ahci berlin driver.

The code is PHY related, but the setup done is SATA specific. I think it
makes sense to keep it here. From what I saw lots of PHY drivers only
power up / down the PHYs.

Lots of port setups are done in the SATA framework, so it would separate
related code into two subsystems.

Antoine

-- 
Antoine Ténart, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
