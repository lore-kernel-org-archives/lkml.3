Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755328Ab3EQDze (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 23:55:34 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:39130 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755046Ab3EQDzc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 23:55:32 -0400
Date: Thu, 16 May 2013 18:15:23 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Alexander Popov <a13xp0p0v88@gmail.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, Anatolij Gustschin <agust@denx.de>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Timur Tabi <timur@tabi.org>,
        Arnd Bergmann <arnd@arndb.de>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH 2/2] powerpc/512x: DMA via LocalPlus Bus testing driver
Message-ID: <20130517011523.GA9555@kroah.com>
References: <1367508195-2420-1-git-send-email-a13xp0p0v88@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1367508195-2420-1-git-send-email-a13xp0p0v88@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 02, 2013 at 07:23:15PM +0400, Alexander Popov wrote:
> This module tests Direct Memory Access to some device on LocalPlus Bus
> for Freescale MPC512x. In other words it tests the bundle
> of mpc512x_lpbfifo and mpc512x_dma drivers.
> 
> This testing driver was multiply used with static RAM (CY62167EV30LL-45ZXI)
> which lives on LocalPlus Bus on our board. This testing driver was used
> instead of the original static RAM driver and it is an abnormal hack.
> That is why I just provide the driver code and don't modify any environment.
> 
> Signed-off-by: Alexander Popov <a13xp0p0v88@gmail.com>
> ---
>  drivers/misc/mpc512x_lpbdma_test.c | 310 +++++++++++++++++++++++++++++++++++++
>  1 file changed, 310 insertions(+)
>  create mode 100644 drivers/misc/mpc512x_lpbdma_test.c

You obviously didn't test your testing driver to see if it would build
in the kernel source tree :(

Care to try again?
