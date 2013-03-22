Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161019Ab3CVQeU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 12:34:20 -0400
Received: from mga01.intel.com ([192.55.52.88]:51718 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933488Ab3CVQeT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 12:34:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,893,1355126400"; 
   d="scan'208";a="306996982"
Date: Fri, 22 Mar 2013 17:34:09 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Magnus Damm <magnus.damm@gmail.com>, Simon Horman <horms@verge.net.au>,
        devicetree-discuss@lists.ozlabs.org,
        Richard Purdie <rpurdie@rpsys.net>,
        Andrew Morton <akpm@linux-foundation.org>, linux-fbdev@vger.kernel.org,
        Guennadi Liakhovetski <g.liakhovetski+renesas@gmail.com>
Subject: Re: [PATCH v3 1/3] mfd: as3711: add OF support
Message-ID: <20130322163409.GA8997@zurbaran>
References: <1363968949-12151-1-git-send-email-g.liakhovetski@gmx.de>
 <1363968949-12151-2-git-send-email-g.liakhovetski@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363968949-12151-2-git-send-email-g.liakhovetski@gmx.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Guennadi,

On Fri, Mar 22, 2013 at 05:15:47PM +0100, Guennadi Liakhovetski wrote:
> Add Flat Device Tree support to the AS3711 MFD driver. This patch just
> allows to bind the driver to I2C devices, instantiated from the DT.
> DT support for AS3711 cell drivers will be added in separate drivers.
> 
> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski+renesas@gmail.com>
> Reviwed-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
>  Documentation/devicetree/bindings/mfd/as3711.txt |   73 ++++++++++++++++++++++
>  drivers/mfd/as3711.c                             |   27 +++++++-
>  2 files changed, 96 insertions(+), 4 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/mfd/as3711.txt
Applied, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
