Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932491Ab3BITA1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2013 14:00:27 -0500
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:5367 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758526Ab3BITAZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2013 14:00:25 -0500
Date: Sat, 9 Feb 2013 20:00:10 +0100
From: Jean Delvare <khali@linux-fr.org>
To: James Ralston <james.d.ralston@intel.com>
Cc: Wolfram Sang <w.sang@pengutronix.de>, linux-i2c@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Seth Heasley <seth.heasley@intel.com>
Subject: Re: [PATCH 3/5] i2c-i801: Add Device IDs for Intel Wellsburg PCH
Message-ID: <20130209200010.1b18fdb3@endymion.delvare>
In-Reply-To: <1360373535-2055-1-git-send-email-james.d.ralston@intel.com>
References: <1360373535-2055-1-git-send-email-james.d.ralston@intel.com>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi James,

On Fri,  8 Feb 2013 17:32:15 -0800, James Ralston wrote:
> This patch adds the SMBus Device IDs for the Intel Wellsburg PCH
> 
> Signed-off-by: James Ralston <james.d.ralston@intel.com>
> ---
>  Documentation/i2c/busses/i2c-i801 |    1 +
>  drivers/i2c/busses/Kconfig        |    1 +
>  drivers/i2c/busses/i2c-i801.c     |    3 +++
>  3 files changed, 5 insertions(+), 0 deletions(-)
> (...)

Seth recently sent a patch adding IDs for the Avoton:
http://marc.info/?l=linux-kernel&m=135959209218860&w=2

Your patch conflicts with his. Please rebase on top of Seth's patch, so
that both patches can be applied in sequence.

> (...)
> --- a/drivers/i2c/busses/i2c-i801.c
> +++ b/drivers/i2c/busses/i2c-i801.c
> (...)
> @@ -165,6 +166,7 @@
>  #define PCI_DEVICE_ID_INTEL_DH89XXCC_SMBUS	0x2330
>  #define PCI_DEVICE_ID_INTEL_5_3400_SERIES_SMBUS	0x3b30
>  #define PCI_DEVICE_ID_INTEL_LYNXPOINT_SMBUS	0x8c22
> +#define PCI_DEVICE_ID_INTEL_WELLSBURG_SMBUS	0x8d22
>  #define PCI_DEVICE_ID_INTEL_LYNXPOINT_LP_SMBUS	0x9c22

Please keep sorted by ID.

-- 
Jean Delvare
