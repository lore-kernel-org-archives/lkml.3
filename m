Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751331AbaLPVey (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 16:34:54 -0500
Received: from mga11.intel.com ([192.55.52.93]:10578 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751043AbaLPVew (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 16:34:52 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="429833182"
Date: Tue, 16 Dec 2014 23:34:47 +0200
From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To: Peter Huewe <PeterHuewe@gmx.de>
Cc: christophe.ricard@gmail.com, linux-api@vger.kernel.org,
        Ashley Lai <ashley@ashleylai.com>, linux-kernel@vger.kernel.org,
        josh@joshtriplett.org, tpmdd-devel@lists.sourceforge.net,
        jason.gunthorpe@obsidianresearch.com,
        trousers-tech@lists.sourceforge.net
Subject: Re: Re: [tpmdd-devel] [PATCH v10 0/8] TPM 2.0 support
Message-ID: <20141216213447.GA24841@intel.com>
References: <1418413600-5400-1-git-send-email-jarkko.sakkinen@linux.intel.com>
 <20141215201757.GA27923@intel.com>
 <trinity-c582edfe-4951-4a31-911d-db0c6f723157-1418764766771@3capp-gmx-bs15>
 <trinity-c704c9fe-b92f-48bd-80cc-a452bd18cc28-1418765537847@3capp-gmx-bs15>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <trinity-c704c9fe-b92f-48bd-80cc-a452bd18cc28-1418765537847@3capp-gmx-bs15>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 16, 2014 at 10:32:18PM +0100, Peter Huewe wrote:
> Hi,
> if I fix this (already adressed issue) 
>  #define TPM2_STARTUP_IN_SIZE \
>         (sizeof(struct tpm_input_header) + \
> -        sizeof(struct tpm2_pcr_read_in))
> +        sizeof(struct tpm2_startup_in))
>  
> it gets detected correctly.
>  
> I'll fix it, no updated patch needed.

Oops, I was too fast :)

> Not sure however if I think to reuse tpm2_startup_in also for shutdown, simply
> because it has  the same size, but ok.

They are equivalent messages except for the command code.

> Peter

/Jarkko
