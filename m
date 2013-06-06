Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753098Ab3FFQoa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 12:44:30 -0400
Received: from 11.mo5.mail-out.ovh.net ([46.105.47.167]:33854 "EHLO
	mo5.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751146Ab3FFQo3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 12:44:29 -0400
Date: Thu, 6 Jun 2013 18:23:36 +0200
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Michal Simek <michal.simek@xilinx.com>
Cc: linux-kernel@vger.kernel.org, Michal Simek <monstr@monstr.eu>,
        Arnd Bergmann <arnd@arndb.de>, Timur Tabi <timur@tabi.org>,
        devicetree-discuss@lists.ozlabs.org, linux-fbdev@vger.kernel.org,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>
X-Ovh-Mailout: 178.32.228.5 (mo5.mail-out.ovh.net)
Subject: Re: [PATCH v4 0/7] xilinxfb changes
Message-ID: <20130606162336.GW19468@game.jcrosoft.org>
References: <cover.1370254386.git.michal.simek@xilinx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1370254386.git.michal.simek@xilinx.com>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 13292937250751359903
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiiedrfeejucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiiedrfeekucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12:13 Mon 03 Jun     , Michal Simek wrote:
> Hi,
> 

Arnd can you take look on it again please

I'll take a look on it next week

Best Regards,
J.
> I have done more changes in the driver to support probing
> on little and big endian system where detection is done
> directly on the hardware.
> I have also done some cleanups to get it to the better shape.
> 
> Thanks for your review,
> Michal
> 
> Changes in v4:
> - Acked by Arnd
> - Remove "video: xilinxfb: Fix sparse warnings"
>   patch because it is trying to fix incorrect API
>   usage and sparse should warn about it.
> 
> Changes in v3:
> - fix commit message
> - Remove out_be IO name from function name
> - Change patch subject from "Do not use out_be32 IO function"
>   to "Do not name out_be32 in function name"
> - New patch in this patchset based on discussions
> - New patch in this patchset based on discussions
> - New patch in this patchset
> - New patch in this patchset based on discussions
> 
> Changes in v2:
> - use of_property_read_u32 helper function
> 
> Michal Simek (7):
>   video: xilinxfb: Fix OF probing on little-endian systems
>   video: xilinxfb: Do not name out_be32 in function name
>   video: xilinxfb: Rename PLB_ACCESS_FLAG to BUS_ACCESS_FLAG
>   video: xilinxfb: Use drvdata->regs_phys instead of physaddr
>   video: xilinxfb: Group bus initialization
>   video: xilinxfb: Add support for little endian accesses
>   video: xilinxfb: Use driver for Xilinx ARM Zynq
> 
>  drivers/video/Kconfig    |   2 +-
>  drivers/video/xilinxfb.c | 135 +++++++++++++++++++++++------------------------
>  2 files changed, 68 insertions(+), 69 deletions(-)
> 
> --
> 1.8.2.3
> 


