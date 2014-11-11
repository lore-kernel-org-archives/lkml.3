Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753461AbaKKIWX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 03:22:23 -0500
Received: from mga14.intel.com ([192.55.52.115]:52069 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753213AbaKKIWG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 03:22:06 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="414704216"
Date: Tue, 11 Nov 2014 10:22:01 +0200
From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Peter Huewe <peterhuewe@gmx.de>, Ashley Lai <ashley@ashleylai.com>,
        Marcel Selhorst <tpmdd@selhorst.net>,
        tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        josh.triplett@intel.com, christophe.ricard@gmail.com,
        jason.gunthorpe@obsidianresearch.com
Subject: Re: [PATCH v6 10/10] tpm: TPM 2.0 sysfs attributes
Message-ID: <20141111082201.GC7088@intel.com>
References: <1415623794-6090-1-git-send-email-jarkko.sakkinen@linux.intel.com>
 <1415623794-6090-11-git-send-email-jarkko.sakkinen@linux.intel.com>
 <20141110180305.GC5296@obsidianresearch.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141110180305.GC5296@obsidianresearch.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 10, 2014 at 11:03:05AM -0700, Jason Gunthorpe wrote:
> On Mon, Nov 10, 2014 at 02:49:54PM +0200, Jarkko Sakkinen wrote:
> 
> >  	if (len > le32_to_cpu(cca->cmd_size)) {
> > -		dev_err(chip->dev,
> > +		dev_err(&chip->dev,
> 
> Is this out of sequence in the patch series?

It is, must have rebased the fixup into wrong commit.

> >  	rc = tpm2_do_selftest(chip);
> > -	if (rc) {
> > -		dev_err(dev, "self-test failed\n");
> > +	if (rc)
> >  		return rc;
> > -	}
> >  
> >  	rc = tpm_chip_register(chip);
> > -	if (rc) {
> > -		dev_err(dev, "registering the chip failed\n");
> > +	if (rc)
> >  		return rc;
> > -	}
> 
> Ditto.
> 
> Also, just:
> 
>    return tpm_chip_register(chip);
> 
> Jason

/Jarkko
