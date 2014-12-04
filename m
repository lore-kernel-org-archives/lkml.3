Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753198AbaLDFwn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 00:52:43 -0500
Received: from mga02.intel.com ([134.134.136.20]:26957 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750858AbaLDFwm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 00:52:42 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,513,1413270000"; 
   d="scan'208";a="618371324"
Date: Thu, 4 Dec 2014 07:52:35 +0200
From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To: Peter =?iso-8859-1?Q?H=FCwe?= <PeterHuewe@gmx.de>
Cc: Ashley Lai <ashley@ashleylai.com>, Marcel Selhorst <tpmdd@selhorst.net>,
        tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        josh.triplett@intel.com, christophe.ricard@gmail.com,
        jason.gunthorpe@obsidianresearch.com, linux-api@vger.kernel.org,
        trousers-tech@lists.sourceforge.net
Subject: Re: [PATCH v8 0/8] TPM 2.0 support
Message-ID: <20141204055235.GA4194@intel.com>
References: <1417559480-13757-1-git-send-email-jarkko.sakkinen@linux.intel.com>
 <201412030016.20268.PeterHuewe@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201412030016.20268.PeterHuewe@gmx.de>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 03, 2014 at 12:16:19AM +0100, Peter Hüwe wrote:
> [SNIP]
> 
> When applying to linux-v3.18-rc6 I get this new coccinelle warning:
> drivers/char/tpm/tpm_i2c_nuvoton.c:607:1-3: WARNING: end returns can be 
> simpified
> 
> 
> make -C ../../../linux/ M=$(pwd) coccicheck

Not a huge problem but I've been only been able to run coccicheck
globally to the whole kernel tree. If I try what you put, it will
just print the usage information of spatch couple of times...

> Peter

/Jarkko
