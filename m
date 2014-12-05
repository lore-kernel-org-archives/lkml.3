Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751937AbaLEHYF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 02:24:05 -0500
Received: from mail-pa0-f47.google.com ([209.85.220.47]:36955 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751309AbaLEHYC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 02:24:02 -0500
Date: Thu, 4 Dec 2014 23:24:02 -0800
From: Olof Johansson <olof@lixom.net>
To: Chunyan Zhang <chunyan.zhang@spreadtrum.com>
Cc: gregkh@linuxfoundation.org, mark.rutland@arm.com, arnd@arndb.de,
        gnomes@lxorguk.ukuu.org.uk, broonie@kernel.org, robh+dt@kernel.org,
        pawel.moll@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, will.deacon@arm.com, catalin.marinas@arm.com,
        jslaby@suse.cz, jason@lakedaemon.net, heiko@sntech.de,
        florian.vaussard@epfl.ch, andrew@lunn.ch, rrichter@cavium.com,
        hytszk@gmail.com, grant.likely@linaro.org, orsonzhai@gmail.com,
        geng.ren@spreadtrum.com, zhizhou.zhang@spreadtrum.com,
        lanqing.liu@spreadtrum.com, zhang.lyra@gmail.com,
        wei.qiao@spreadtrum.com, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-api@vger.kernel.org,
        linux-kernel@vger.kernel.org, arm@kernel.org,
        linux-serial@vger.kernel.org, sprdlinux@freelists.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v4 0/5] Add Spreadtrum Sharkl64 Platform support
Message-ID: <20141205072402.GC29274@quad.lixom.net>
References: <sc9836v4>
 <1417692860-18841-1-git-send-email-chunyan.zhang@spreadtrum.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417692860-18841-1-git-send-email-chunyan.zhang@spreadtrum.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 04, 2014 at 07:34:15PM +0800, Chunyan Zhang wrote:
> Spreadtrum is a rapid growing chip vendor providing smart phone total solutions.
> 
> Sharkl64 Platform is nominated as a SoC infrastructure that supports 4G/3G/2G
> standards based on ARMv8 multiple core architecture.Now we have only one
> SoC(SC9836) based on this Platform in developing.
> 
> This patchset adds Sharkl64 support in arm64 device tree and the serial driver
> of SC9836-UART.
> 
> This patchset also has patches which address "sprd" prefix and DT compatible
> strings for nodes which appear un-documented.
> 
> This version code was tesed both on Fast Mode and sc9836-fpga board.
> We use the latest boot-wrapper-aarch64 as the bootloader.

Hi,

We only got 3 of the 5 patches of this version (1, 2 and 4). Can you
resend the dts patch to us (I'm guessing the serial one will go through Greg).


Thanks,

-Olof
