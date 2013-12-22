Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755835Ab3LVT63 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Dec 2013 14:58:29 -0500
Received: from mail-pd0-f171.google.com ([209.85.192.171]:63128 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755282Ab3LVT62 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Dec 2013 14:58:28 -0500
Date: Sun, 22 Dec 2013 11:56:19 -0800
From: Olof Johansson <olof@lixom.net>
To: Jonas Jensen <jonas.jensen@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, arm@kernel.org, linux@arm.linux.org.uk,
        arnd@arndb.de, soren.brinkmann@xilinx.com,
        peter.crosthwaite@xilinx.com, linux@roeck-us.net
Subject: Re: [PATCH v6 0/2] ARM: mach-moxart: add MOXA ART SoC support
Message-ID: <20131222195619.GG9144@quad.lixom.net>
References: <1387371526-15309-1-git-send-email-jonas.jensen@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1387371526-15309-1-git-send-email-jonas.jensen@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 18, 2013 at 01:58:44PM +0100, Jonas Jensen wrote:
> Thanks for the replies!
> 
> This should tick the boxes on feedback except for one detail
> on the fixed rate clock:
> 
> Moving fixed-clock "ref12" from .dtsi to .dts proved problematic
> for other clocks, this is why ref12 is still in SoC.
> 
> My assertion is that "fixed-clock" clocks are probed later when
> placed in .dts (see diff and boot log below).
> of_clk_get() from clk_pll in .dtsi fails, i.e. fixed-clock ref12
> is not added as a provider in time before clk_pll loads.

Argh, I didn't see this version before I applied v5. So I dropped v5 and
replaced with v6.


-Olof
