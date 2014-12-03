Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751638AbaLCKKd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 05:10:33 -0500
Received: from mga01.intel.com ([192.55.52.88]:3928 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750891AbaLCKKb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 05:10:31 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="424479651"
Date: Wed, 3 Dec 2014 12:10:26 +0200
From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To: Peter =?iso-8859-1?Q?H=FCwe?= <PeterHuewe@gmx.de>
Cc: Ashley Lai <ashley@ashleylai.com>, Marcel Selhorst <tpmdd@selhorst.net>,
        tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        josh.triplett@intel.com, christophe.ricard@gmail.com,
        jason.gunthorpe@obsidianresearch.com, linux-api@vger.kernel.org,
        trousers-tech@lists.sourceforge.net
Subject: Re: [PATCH v8 0/8] TPM 2.0 support
Message-ID: <20141203101026.GA14038@intel.com>
References: <1417559480-13757-1-git-send-email-jarkko.sakkinen@linux.intel.com>
 <201412022355.34544.PeterHuewe@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201412022355.34544.PeterHuewe@gmx.de>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 02, 2014 at 11:55:34PM +0100, Peter Hüwe wrote:
> Hi Jarkko,
> 
> 
> Am Dienstag, 2. Dezember 2014, 23:31:12 schrieb Jarkko Sakkinen:
> > This patch set enables TPM2 protocol and provides drivers for FIFO and
> > CRB interfaces. This patch set does not export any sysfs attributes for
> > TPM 2.0 because existing sysfs attributes have three non-trivial issues:
> > 
> 
> 
> which tree are you basing your patches against?
> Can you use 
> https://github.com/PeterHuewe/linux-tpmdd for-james
>  please?

Yes, just started preparing v9, will be ready in few hours. My apologies
for the compilications!

> Thanks,
> Peter

/Jarkko
