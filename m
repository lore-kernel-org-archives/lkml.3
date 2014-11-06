Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751480AbaKFQlv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 11:41:51 -0500
Received: from mail.csclub.uwaterloo.ca ([129.97.134.52]:34106 "EHLO
	mail.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751133AbaKFQlu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 11:41:50 -0500
From: "Lennart Sorensen" <lsorense@csclub.uwaterloo.ca>
Date: Thu, 6 Nov 2014 11:41:48 -0500
To: Nishanth Menon <nm@ti.com>
Cc: Tony Lindgren <tony@atomide.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-omap@vger.kernel.org, balbi@ti.com, gerald@granddesignsgroup.com,
        fcooper@ti.com, beagleboard@googlegroups.com
Subject: Re: [PATCH] ARM: dts: Add am57xx-beagle-x15
Message-ID: <20141106164148.GJ24112@csclub.uwaterloo.ca>
References: <1415290702-11353-1-git-send-email-nm@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415290702-11353-1-git-send-email-nm@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 06, 2014 at 10:18:22AM -0600, Nishanth Menon wrote:
> BeagleBoard-X15 is the next generation Open Source Hardware
> BeagleBoard based on TI's AM5728 SoC featuring dual core 1.5GHZ A15
> processor. The platform features 2GB DDR3L (w/dual 32bit busses),
> eSATA, 3 USB3.0 ports, integrated HDMI (1920x108@60), separate LCD
> port, video In port, 4GB eMMC, uSD, Analog audio in/out, dual 1G
> Ethernet.

Oh neat, you put a USB3 hub on the board?

I really should cleanup and submit my patch to make the system time not
run 576ppm too fast on the AM57xx.

This will sure be a nice board when you get it released.  I will have
to get one.

-- 
Len Sorensen
