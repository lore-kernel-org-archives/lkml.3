Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761623Ab3JPUOW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 16:14:22 -0400
Received: from mga03.intel.com ([143.182.124.21]:37412 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757764Ab3JPUOV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 16:14:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,508,1378882800"; 
   d="scan'208";a="412133140"
Date: Wed, 16 Oct 2013 13:14:16 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Matt Fleming <matt@console-pimps.org>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tony Luck <tony.luck@intel.com>, Seiji Aguchi <seiji.aguchi@hds.com>,
        x86@kernel.org, Matt Fleming <matt.fleming@intel.com>
Subject: Re: [PATCH 5/5] efi: Capsule update support and pstore backend
Message-ID: <20131016201416.GG7456@tassilo.jf.intel.com>
References: <1381931460-6999-1-git-send-email-matt@console-pimps.org>
 <1381931460-6999-6-git-send-email-matt@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1381931460-6999-6-git-send-email-matt@console-pimps.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +	  It should be noted that enabling this opton will pass a capsule
> +	  to the firmware on every boot. Some firmware will not allow a
> +	  user to enter the BIOS setup when a capsule has been registered
> +	  on the previous boot.

That sounds like a problem. Can this be fixed to only do it on demand?

> +
> +	  Many EFI machines have buggy implementations of the UpdateCapsule()
> +	  runtime service. This option will enable code that may not function
> +	  correctly with your firmware.

Do we need white/black lists? 

Controlling such things form CONFIG is not very good.

-Andi
