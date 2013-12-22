Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756029Ab3LVUD3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Dec 2013 15:03:29 -0500
Received: from mail-pd0-f182.google.com ([209.85.192.182]:34081 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755282Ab3LVUD1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Dec 2013 15:03:27 -0500
Date: Sun, 22 Dec 2013 12:01:19 -0800
From: Olof Johansson <olof@lixom.net>
To: Jonas Jensen <jonas.jensen@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, arm@kernel.org, linux@arm.linux.org.uk,
        arnd@arndb.de, soren.brinkmann@xilinx.com,
        peter.crosthwaite@xilinx.com, linux@roeck-us.net
Subject: Re: [PATCH v7 0/2] ARM: mach-moxart: add MOXA ART SoC support
Message-ID: <20131222200119.GH9144@quad.lixom.net>
References: <1387450064-6598-1-git-send-email-jonas.jensen@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1387450064-6598-1-git-send-email-jonas.jensen@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 19, 2013 at 11:47:42AM +0100, Jonas Jensen wrote:
> The reason behind why fixed rate clock "ref12" couldn't be moved from
> .dtsi to .dts:
> 
> There was nothing else in "clocks { .. }", the entire block was then
> deleted from .dtsi.
> 
> If a skeleton "clocks { .. }" remain in .dtsi, the node can then be
> moved to .dts, and of_clk_get() works again.
> 
> Changes since v6:
> 
> 1. move fixed rate clock "ref12" from .dtsi to .dts
> 2. sort new entry alphabetically in arch/arm/Kconfig
> 3. rebase to next-20131219: arch/arm/Makefile arch/arm/Kconfig
> 
> Applies to next-20131219
> 
> Jonas Jensen (2):
>   ARM: mach-moxart: add MOXA ART SoC platform files
>   ARM: mach-moxart: add MOXA ART SoC device tree files

Please just send an incremental patch to fixup, I'm not going to rebuild
branches yet again because of a third version within a few hours when I've
already applied and dropped twice. :)

-Olof
