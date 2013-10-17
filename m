Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753247Ab3JQXTb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 19:19:31 -0400
Received: from mga11.intel.com ([192.55.52.93]:32243 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753143Ab3JQXT3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 19:19:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,518,1378882800"; 
   d="scan'208";a="412905193"
Date: Thu, 17 Oct 2013 16:19:18 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Matt Fleming <matt@console-pimps.org>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, linux-efi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Tony Luck <tony.luck@intel.com>,
        Seiji Aguchi <seiji.aguchi@hds.com>, x86@kernel.org,
        Matt Fleming <matt.fleming@intel.com>
Subject: Re: [PATCH 5/5] efi: Capsule update support and pstore backend
Message-ID: <20131017231918.GL7456@tassilo.jf.intel.com>
References: <1381931460-6999-1-git-send-email-matt@console-pimps.org>
 <1381931460-6999-6-git-send-email-matt@console-pimps.org>
 <20131016141939.GA28684@srcf.ucam.org>
 <20131017115514.GE10834@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131017115514.GE10834@console-pimps.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > I'm a little uneasy having this run by default if enabled, even if it's 
> > disabled by default in the config.
> 
> What would be the canonical way to enable this feature then? Have a file

White list systems and a option to force enable.

-Andi

