Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752090Ab3GXRtd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 13:49:33 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:51564 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751005Ab3GXRtb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 13:49:31 -0400
From: "Gupta, Pekon" <pekon@ti.com>
To: Olof Johansson <olof@lixom.net>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
CC: "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        David Woodhouse <dwmw2@infradead.org>
Subject: RE: [PATCH] mtd: nand: omap2: Fix compilation warning
Thread-Topic: [PATCH] mtd: nand: omap2: Fix compilation warning
Thread-Index: AQHOiIZP4fKoAPBsxUWaHAa/8V0CRZl0Fjew
Date: Wed, 24 Jul 2013 17:48:55 +0000
Message-ID: <20980858CB6D3A4BAE95CA194937D5E73E9ED5F3@DBDE04.ent.ti.com>
References: <1374681392-6183-1-git-send-email-olof@lixom.net>
In-Reply-To: <1374681392-6183-1-git-send-email-olof@lixom.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.170.142]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Olof,

> 
> fb1585bc13b (mtd: nand: omap2: clean-up BCHx_HW and BCHx_SW ECC
> configurations in device_probe) introduced a warning when the new option
> is disabled, i.e. with omap2plus_defconfig:
> 
> drivers/mtd/nand/omap2.c:1075:13: warning: 'omap3_enable_hwecc_bch'
> defined but not used [-Wunused-function]
> 
> Fix this by rescoping the ifdef. Also remove a redudant #endif/#ifdef
> pair.
> 
> Signed-off-by: Olof Johansson <olof@lixom.net>
> ---

Thanks much..
But just to remind, this commit fb1585b in linux-next needs to be reverted.
This patch is leftover by mistake because other dependent patches of 
this series were dropped. This will not only break omap2-nand driver,
but might also break the build.

http://lists.infradead.org/pipermail/linux-mtd/2013-July/047441.html

Please let me know, if something needs to be done from my-side to
get this reverted. I have already re-sent a updated version of this series
with fixes & copying devicetree-discuss.

http://lists.infradead.org/pipermail/linux-mtd/2013-July/047530.html


with regards, pekon
