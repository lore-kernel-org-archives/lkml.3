Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934648Ab3JPOTv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 10:19:51 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:55259 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934351Ab3JPOTu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 10:19:50 -0400
Date: Wed, 16 Oct 2013 15:19:39 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Matt Fleming <matt@console-pimps.org>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>, Tony Luck <tony.luck@intel.com>,
        Seiji Aguchi <seiji.aguchi@hds.com>, x86@kernel.org,
        Matt Fleming <matt.fleming@intel.com>
Subject: Re: [PATCH 5/5] efi: Capsule update support and pstore backend
Message-ID: <20131016141939.GA28684@srcf.ucam.org>
References: <1381931460-6999-1-git-send-email-matt@console-pimps.org>
 <1381931460-6999-6-git-send-email-matt@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1381931460-6999-6-git-send-email-matt@console-pimps.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 16, 2013 at 02:51:00PM +0100, Matt Fleming wrote:

> +	  Many EFI machines have buggy implementations of the UpdateCapsule()
> +	  runtime service. This option will enable code that may not function
> +	  correctly with your firmware.

Where by "May not function correctly" you mean "May crash the system"? 
I'm a little uneasy having this run by default if enabled, even if it's 
disabled by default in the config.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
