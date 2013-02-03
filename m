Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753879Ab3BCWb1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 17:31:27 -0500
Received: from mga14.intel.com ([143.182.124.37]:48211 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753777Ab3BCWbY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 17:31:24 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,595,1355126400"; 
   d="scan'208";a="198290462"
Date: Sun, 3 Feb 2013 23:31:18 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: "Vishwanathrao Badarkhe, Manish" <manishv.b@ti.com>
Cc: devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        davinci-linux-open-source@linux.davincidsp.com, anilkumar@ti.com,
        tony@atomide.com, hs@denx.de, broonie@opensource.wolfsonmicro.com,
        khilman@deeprootsystems.com, nsekhar@ti.com, linus.walleij@linaro.org,
        linux@arm.linux.org.uk, rob@landley.net, rob.herring@calxeda.com,
        grant.likely@secretlab.ca
Subject: Re: [PATCH V2 4/6] mfd: tps6507x: add device-tree support.
Message-ID: <20130203223118.GU8476@sortiz-mobl>
References: <1359445134-13323-1-git-send-email-manishv.b@ti.com>
 <1359445134-13323-5-git-send-email-manishv.b@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1359445134-13323-5-git-send-email-manishv.b@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Manish,

On Tue, Jan 29, 2013 at 01:08:52PM +0530, Vishwanathrao Badarkhe, Manish wrote:
> Add device tree based initialization support for TI's
> tps6507x mfd device.
> 
> Signed-off-by: Vishwanathrao Badarkhe, Manish <manishv.b@ti.com>
> ---
> Changes since V1:
>  - updated subject line for commit.
> 
> :100644 100644 409afa2... 5ad4b77... M	drivers/mfd/tps6507x.c
>  drivers/mfd/tps6507x.c |    9 +++++++++
>  1 files changed, 9 insertions(+), 0 deletions(-)
Applied, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
