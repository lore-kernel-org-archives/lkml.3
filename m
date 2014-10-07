Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932231AbaJGTPt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 15:15:49 -0400
Received: from mga01.intel.com ([192.55.52.88]:61866 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932130AbaJGTPr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 15:15:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,672,1406617200"; 
   d="scan'208";a="601923713"
Date: Tue, 7 Oct 2014 22:15:42 +0300
From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Peter Huewe <peterhuewe@gmx.de>, Ashley Lai <ashley@ashleylai.com>,
        Marcel Selhorst <tpmdd@selhorst.net>, linux-api@vger.kernel.org,
        tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [tpmdd-devel] [PATCH v2 2/7] tpm: two-phase chip management
 functions
Message-ID: <20141007191542.GA31645@intel.com>
References: <1412701277-27794-1-git-send-email-jarkko.sakkinen@linux.intel.com>
 <1412701277-27794-3-git-send-email-jarkko.sakkinen@linux.intel.com>
 <20141007175017.GA10432@obsidianresearch.com>
 <20141007180417.GA29459@intel.com>
 <20141007182756.GA10774@obsidianresearch.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141007182756.GA10774@obsidianresearch.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 07, 2014 at 12:27:56PM -0600, Jason Gunthorpe wrote:
> On Tue, Oct 07, 2014 at 09:04:17PM +0300, Jarkko Sakkinen wrote:
> 
> > > Did you test compile all the drivers? One of my git commits on github
> > > has some hackery to make that possible on x86.
> > 
> > Yeah, I compiled all the drivers:
> > 
> > $ grep CONFIG_TCG .config
> > CONFIG_TCG_TPM=m
> > CONFIG_TCG_TIS=m
> > CONFIG_TCG_TIS_I2C_ATMEL=m
> > CONFIG_TCG_TIS_I2C_INFINEON=m
> > CONFIG_TCG_TIS_I2C_NUVOTON=m
> > CONFIG_TCG_NSC=m
> > CONFIG_TCG_ATMEL=m
> > CONFIG_TCG_INFINEON=m
> > CONFIG_TCG_ST33_I2C=m
> > CONFIG_TCG_XEN=m
> > CONFIG_TCG_CRB=m
> 
> CONFIG_TCG_IBMVTPM is missing, apply this:
> 
> https://github.com/jgunthorpe/linux/commit/74afd69de603783858283f9b337e1694988964f8

Oops, how did that go unnoticed. Will do.

> Jason

/Jarkko
