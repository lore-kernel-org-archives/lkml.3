Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754106AbaCKDj2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 23:39:28 -0400
Received: from mga09.intel.com ([134.134.136.24]:54514 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752879AbaCKDj0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 23:39:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,628,1389772800"; 
   d="scan'208";a="497415821"
From: "Chew, Chiau Ee" <chiau.ee.chew@intel.com>
To: Wolfram Sang <wsa@the-dreams.de>
CC: Mika Westerberg <mika.westerberg@linux.intel.com>,
        "Lim, Lee Booi" <lee.booi.lim@intel.com>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCHv2 RESEND] i2c: designware-pci: set ideal HCNT, LCNT and
 SDA hold time value
Thread-Topic: [PATCHv2 RESEND] i2c: designware-pci: set ideal HCNT, LCNT and
 SDA hold time value
Thread-Index: AQHPPNpz5BfKLzT1306ySfjPdujVX5rbO3KA
Date: Tue, 11 Mar 2014 03:39:22 +0000
Message-ID: <604BF5F4C5D71041942BC7E84ED659EA0155D80D@PGSMSX103.gar.corp.intel.com>
References: <1394537625-27205-1-git-send-email-chiau.ee.chew@intel.com>
In-Reply-To: <1394537625-27205-1-git-send-email-chiau.ee.chew@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.30.20.206]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Subject: [PATCHv2 RESEND] i2c: designware-pci: set ideal HCNT, LCNT and SDA
> hold time value
> 
> From: Chew, Chiau Ee <chiau.ee.chew@intel.com>
> 
> On Intel BayTrail, there was case whereby the resulting fast mode bus speed
> becomes slower (~20% slower compared to expected speed) if using the
> HCNT/LCNT calculated in the core layer. Thus, this patch is added to allow pci
> glue layer to pass in optimal HCNT/LCNT/SDA hold time values to core layer
> since the core layer supports cofigurable HCNT/LCNT/SDA hold time values
> now.
> 
> Signed-off-by: Chew, Chiau Ee <chiau.ee.chew@intel.com>
> ---
> v2 changelog:
> * Add 'dw_' prefix to struct scl_sda_cfg
> * Add Baytrail HCNT/LCNT/SDA hold time values directly in the
>   struct instead of using macro definition
> * Replace tab before "=" with space in struct
> 
>  drivers/i2c/busses/i2c-designware-pcidrv.c |   28
> ++++++++++++++++++++++++++++
>  1 files changed, 28 insertions(+), 0 deletions(-)
> 

I have misplaced the changelog in the previous v2 patch which would cause the removal of signed-off-by line. I'm resending this to fix that problem. Sorry for any confusion and inconvenience caused.


