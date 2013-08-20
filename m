Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751815Ab3HTBel (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 21:34:41 -0400
Received: from mga02.intel.com ([134.134.136.20]:40676 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751545Ab3HTBej (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 21:34:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,915,1367996400"; 
   d="scan'208";a="389847109"
Date: Tue, 20 Aug 2013 03:34:33 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Michael Grzeschik <m.grzeschik@pengutronix.de>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel@pengutronix.de, Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [PATCH] mc13xxx-ts: use zero as default value if no pdata was
 defined
Message-ID: <20130820013433.GE13324@zurbaran>
References: <1376396070-24507-1-git-send-email-m.grzeschik@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1376396070-24507-1-git-send-email-m.grzeschik@pengutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michael,

On Tue, Aug 13, 2013 at 02:14:30PM +0200, Michael Grzeschik wrote:
> In case of devicetree, we currently don't have a way to append pdata for
> the touchscreen. The current approach is to bail out in that case.
> This patch makes it possible to probe the touchscreen without pdata
> and use zero as default values for the atox and ato adc conversion.
Would that still make the touchscreen somehow functional ?
If that's the case, and if Dmitry is fine with the ts part of this
patch, could you please separate the mfd part of this patch into a
separate one ?

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
