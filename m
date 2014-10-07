Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932177AbaJGS2G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 14:28:06 -0400
Received: from quartz.orcorp.ca ([184.70.90.242]:57293 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932151AbaJGS2D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 14:28:03 -0400
Date: Tue, 7 Oct 2014 12:27:56 -0600
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc: Peter Huewe <peterhuewe@gmx.de>, Ashley Lai <ashley@ashleylai.com>,
        Marcel Selhorst <tpmdd@selhorst.net>, linux-api@vger.kernel.org,
        tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [tpmdd-devel] [PATCH v2 2/7] tpm: two-phase chip management
 functions
Message-ID: <20141007182756.GA10774@obsidianresearch.com>
References: <1412701277-27794-1-git-send-email-jarkko.sakkinen@linux.intel.com>
 <1412701277-27794-3-git-send-email-jarkko.sakkinen@linux.intel.com>
 <20141007175017.GA10432@obsidianresearch.com>
 <20141007180417.GA29459@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141007180417.GA29459@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.161
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 07, 2014 at 09:04:17PM +0300, Jarkko Sakkinen wrote:

> > Did you test compile all the drivers? One of my git commits on github
> > has some hackery to make that possible on x86.
> 
> Yeah, I compiled all the drivers:
> 
> $ grep CONFIG_TCG .config
> CONFIG_TCG_TPM=m
> CONFIG_TCG_TIS=m
> CONFIG_TCG_TIS_I2C_ATMEL=m
> CONFIG_TCG_TIS_I2C_INFINEON=m
> CONFIG_TCG_TIS_I2C_NUVOTON=m
> CONFIG_TCG_NSC=m
> CONFIG_TCG_ATMEL=m
> CONFIG_TCG_INFINEON=m
> CONFIG_TCG_ST33_I2C=m
> CONFIG_TCG_XEN=m
> CONFIG_TCG_CRB=m

CONFIG_TCG_IBMVTPM is missing, apply this:

https://github.com/jgunthorpe/linux/commit/74afd69de603783858283f9b337e1694988964f8

Jason
