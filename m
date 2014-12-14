Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753677AbaLNO5S (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2014 09:57:18 -0500
Received: from mga11.intel.com ([192.55.52.93]:37110 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751475AbaLNO5Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2014 09:57:16 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="428797386"
Message-ID: <1418569030.9230.7.camel@linux.intel.com>
Subject: Re: [PATCH v10 1/8] tpm: merge duplicate transmit_cmd() functions
From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To: Stefan Berger <stefanb@linux.vnet.ibm.com>
Cc: Peter Huewe <peterhuewe@gmx.de>, Ashley Lai <ashley@ashleylai.com>,
        Marcel Selhorst <tpmdd@selhorst.net>,
        tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        josh@joshtriplett.org, christophe.ricard@gmail.com,
        jason.gunthorpe@obsidianresearch.com, linux-api@vger.kernel.org,
        trousers-tech@lists.sourceforge.net
Date: Sun, 14 Dec 2014 16:57:10 +0200
In-Reply-To: <548D98B8.3010003@linux.vnet.ibm.com>
References: <1418413600-5400-1-git-send-email-jarkko.sakkinen@linux.intel.com>
	 <1418413600-5400-2-git-send-email-jarkko.sakkinen@linux.intel.com>
	 <548D98B8.3010003@linux.vnet.ibm.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-12-14 at 09:03 -0500, Stefan Berger wrote:
> On 12/12/2014 02:46 PM, Jarkko Sakkinen wrote:
> > Merged transmit_cmd() functions in tpm-interface.c and tpm-sysfs.c.
> > Added "tpm_" prefix for consistency sake. Changed cmd parameter as
> > opaque. This enables to use separate command structures for TPM1
> > and TPM2 commands in future. Loose coupling works fine here.
> >
> > Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> > Reviewed-by: Jasob Gunthorpe <jason.gunthorpe@obsidianresearch.com>
> > Reviewed-by: Stephan Berger <stephan.berger@linux.vnet.ibm.com>
> 
> Not quite ... Stefan Berger <stefanb@linux.vnet.ibm.com>

Oops. Peter, I guess you could fix those or? My apologies.

>      Stefan

/Jarkko



