Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752068AbaLNPmk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2014 10:42:40 -0500
Received: from mga11.intel.com ([192.55.52.93]:12772 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751487AbaLNPmh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2014 10:42:37 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,575,1413270000"; 
   d="scan'208";a="647425919"
Date: Sun, 14 Dec 2014 17:42:33 +0200
From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To: peterhuewe@gmx.de
Cc: Stefan Berger <stefanb@linux.vnet.ibm.com>,
        Ashley Lai <ashley@ashleylai.com>,
        Marcel Selhorst <tpmdd@selhorst.net>,
        tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        josh@joshtriplett.org, christophe.ricard@gmail.com,
        jason.gunthorpe@obsidianresearch.com, linux-api@vger.kernel.org,
        trousers-tech@lists.sourceforge.net
Subject: Re: [PATCH v10 1/8] tpm: merge duplicate transmit_cmd() functions
Message-ID: <20141214154233.GA14110@intel.com>
References: <1418413600-5400-1-git-send-email-jarkko.sakkinen@linux.intel.com>
 <1418413600-5400-2-git-send-email-jarkko.sakkinen@linux.intel.com>
 <548D98B8.3010003@linux.vnet.ibm.com>
 <1418569030.9230.7.camel@linux.intel.com>
 <889c95a4-ae60-44db-be8a-fd56a9497c78@email.android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <889c95a4-ae60-44db-be8a-fd56a9497c78@email.android.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 14, 2014 at 04:31:10PM +0100, peterhuewe@gmx.de wrote:
> 
> 
> On 14. Dezember 2014 15:57:10 MEZ, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com> wrote:
> >On Sun, 2014-12-14 at 09:03 -0500, Stefan Berger wrote:
> >> On 12/12/2014 02:46 PM, Jarkko Sakkinen wrote:
> >> > Merged transmit_cmd() functions in tpm-interface.c and tpm-sysfs.c.
> >> > Added "tpm_" prefix for consistency sake. Changed cmd parameter as
> >> > opaque. This enables to use separate command structures for TPM1
> >> > and TPM2 commands in future. Loose coupling works fine here.
> >> >
> >> > Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> >> > Reviewed-by: Jasob Gunthorpe <jason.gunthorpe@obsidianresearch.com>
> >> > Reviewed-by: Stephan Berger <stephan.berger@linux.vnet.ibm.com>
> >> 
> >> Not quite ... Stefan Berger <stefanb@linux.vnet.ibm.com>
> >
> >Oops. Peter, I guess you could fix those or? My apologies.
> >
> >>      Stefan
> >
> >/Jarkko
> I'll fix this,
> No problem.

Thank you.

> Peter

/Jarkko
