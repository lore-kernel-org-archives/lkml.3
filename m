Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755915AbaIWOB6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 10:01:58 -0400
Received: from top.free-electrons.com ([176.31.233.9]:57932 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753292AbaIWOB5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 10:01:57 -0400
Date: Tue, 23 Sep 2014 16:01:52 +0200
From: Antoine Tenart <antoine.tenart@free-electrons.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org,
        Antoine Tenart <antoine.tenart@free-electrons.com>,
        sebastian.hesselbarth@gmail.com, thomas.petazzoni@free-electrons.com,
        zmxu@marvell.com, devicetree@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, alexandre.belloni@free-electrons.com,
        jszhang@marvell.com
Subject: Re: [PATCH v4 0/9] ARM: Berlin: Ethernet support
Message-ID: <20140923140152.GD18924@kwain>
References: <1411474536-22626-1-git-send-email-antoine.tenart@free-electrons.com>
 <3200502.7xjfrZcKCM@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3200502.7xjfrZcKCM@wuerfel>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 23, 2014 at 02:41:47PM +0200, Arnd Bergmann wrote:
> On Tuesday 23 September 2014 14:15:27 Antoine Tenart wrote:
> > 
> > This series introduce support for the Ethernet controller on Berlin SoCs,
> > using the existing pxa168 Ethernet driver. In order to do this, DT
> > support is added to the driver alongside some other modifications and
> > fixes.
> > 
> 
> Looks great overall, I've commented on two issues I've found, but only
> the phy-addr one really needs to be addressed. Once that is out of the
> way, please add
> 
> Acked-by: Arnd Bergmann <arnd@arndb.de>

Thanks!

Antoine

-- 
Antoine Ténart, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
