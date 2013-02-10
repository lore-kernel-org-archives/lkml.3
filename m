Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758775Ab3BJSiu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2013 13:38:50 -0500
Received: from sauhun.de ([89.238.76.85]:48995 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756463Ab3BJSit (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2013 13:38:49 -0500
Date: Sun, 10 Feb 2013 19:38:45 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: Jean Delvare <khali@linux-fr.org>
Cc: James Ralston <james.d.ralston@intel.com>, linux-i2c@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Seth Heasley <seth.heasley@intel.com>
Subject: Re: [PATCH 3/5] i2c-i801: Add Device IDs for Intel Wellsburg PCH
Message-ID: <20130210183845.GC12760@nekote.pengutronix.de>
References: <1360373535-2055-1-git-send-email-james.d.ralston@intel.com>
 <20130209200010.1b18fdb3@endymion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130209200010.1b18fdb3@endymion.delvare>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Seth recently sent a patch adding IDs for the Avoton:
> http://marc.info/?l=linux-kernel&m=135959209218860&w=2
> 
> Your patch conflicts with his. Please rebase on top of Seth's patch, so
> that both patches can be applied in sequence.

Yes, please.

> > --- a/drivers/i2c/busses/i2c-i801.c
> > +++ b/drivers/i2c/busses/i2c-i801.c
> > (...)
> > @@ -165,6 +166,7 @@
> >  #define PCI_DEVICE_ID_INTEL_DH89XXCC_SMBUS	0x2330
> >  #define PCI_DEVICE_ID_INTEL_5_3400_SERIES_SMBUS	0x3b30
> >  #define PCI_DEVICE_ID_INTEL_LYNXPOINT_SMBUS	0x8c22
> > +#define PCI_DEVICE_ID_INTEL_WELLSBURG_SMBUS	0x8d22
> >  #define PCI_DEVICE_ID_INTEL_LYNXPOINT_LP_SMBUS	0x9c22
> 
> Please keep sorted by ID.

Hum? This table looks sorted by numbers to me, so OK.

