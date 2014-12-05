Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753375AbaLENGb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 08:06:31 -0500
Received: from mga02.intel.com ([134.134.136.20]:18504 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751258AbaLENG3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 08:06:29 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,522,1413270000"; 
   d="scan'208";a="648854929"
Date: Fri, 5 Dec 2014 15:06:00 +0200
From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To: Peter =?iso-8859-1?Q?H=FCwe?= <PeterHuewe@gmx.de>
Cc: Ashley Lai <ashley@ashleylai.com>, Marcel Selhorst <tpmdd@selhorst.net>,
        tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        josh.triplett@intel.com, christophe.ricard@gmail.com,
        jason.gunthorpe@obsidianresearch.com, linux-api@vger.kernel.org,
        trousers-tech@lists.sourceforge.net,
        Will Arthur <will.c.arthur@intel.com>
Subject: Re: [PATCH v9 8/8] tpm: TPM 2.0 FIFO Interface
Message-ID: <20141205130600.GB6993@intel.com>
References: <1417672518-4530-1-git-send-email-jarkko.sakkinen@linux.intel.com>
 <1417672518-4530-9-git-send-email-jarkko.sakkinen@linux.intel.com>
 <201412042246.25662.PeterHuewe@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201412042246.25662.PeterHuewe@gmx.de>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 04, 2014 at 10:46:25PM +0100, Peter Hüwe wrote:
> Am Donnerstag, 4. Dezember 2014, 06:55:18 schrieb Jarkko Sakkinen:
> > From: Will Arthur <will.c.arthur@intel.com>
> > 
> > Detect TPM 2.0 by using the extended STS (STS3) register. For TPM 2.0,
> > instead of calling tpm_get_timeouts(), assign duration and timeout
> > values defined in the TPM 2.0 PTP specification.
> > 
> > Signed-off-by: Will Arthur <will.c.arthur@intel.com>
> > Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> > ---
> Should we change the KConfig string?
>  TPM Interface Specification 1.2 Interface
> is not quite accurate anymore after applying this patch.

Would make sense. Does this require a new patch set?

> Thanks,
> Peter

/Jarkko
