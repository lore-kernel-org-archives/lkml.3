Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932378AbaIIQg1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 12:36:27 -0400
Received: from top.free-electrons.com ([176.31.233.9]:59513 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753735AbaIIQgZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 12:36:25 -0400
Date: Tue, 9 Sep 2014 18:36:22 +0200
From: Antoine Tenart <antoine.tenart@free-electrons.com>
To: Jason Cooper <jason@lakedaemon.net>
Cc: Antoine Tenart <antoine.tenart@free-electrons.com>,
        sebastian.hesselbarth@gmail.com, alexandre.belloni@free-electrons.com,
        thomas.petazzoni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 5/8] net: pxa168_eth: get and set the mac address on
 the Ethernet controller
Message-ID: <20140909163622.GA28752@kwain>
References: <1410273848-24663-1-git-send-email-antoine.tenart@free-electrons.com>
 <1410273848-24663-6-git-send-email-antoine.tenart@free-electrons.com>
 <20140909162958.GS30828@titan.lakedaemon.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140909162958.GS30828@titan.lakedaemon.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jason,

On Tue, Sep 09, 2014 at 12:29:58PM -0400, Jason Cooper wrote:
> On Tue, Sep 09, 2014 at 04:44:05PM +0200, Antoine Tenart wrote:
> > When changing the MAC address, in addition to updating the dev_addr in
> > the net_device structure, this patch also update the MAC address
> > registers (high and low) of the Ethernet controller with the new MAC.
> > The address stored in these registers is used for IEEE 802.3x Ethernet
> > flow control, which is already enabled.
> > 
> > This patch also tries reading the MAC address stored in these registers
> > when probing the driver, to use the MAC address set by the bootloader
> > and avoid using a random one.
> 
> Hmm, the wording here seems odd.  I think the preference should be:
> 
>  1) bootloader-supplied addr via DT
>  2) addr read from device
>  3) randomly generated one.

I agree. I'll update that.

Antoine

-- 
Antoine Ténart, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
