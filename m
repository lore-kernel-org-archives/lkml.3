Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753888Ab3JQLzV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 07:55:21 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:43352 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751073Ab3JQLzT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 07:55:19 -0400
Date: Thu, 17 Oct 2013 12:55:14 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>, Tony Luck <tony.luck@intel.com>,
        Seiji Aguchi <seiji.aguchi@hds.com>, x86@kernel.org,
        Matt Fleming <matt.fleming@intel.com>
Subject: Re: [PATCH 5/5] efi: Capsule update support and pstore backend
Message-ID: <20131017115514.GE10834@console-pimps.org>
References: <1381931460-6999-1-git-send-email-matt@console-pimps.org>
 <1381931460-6999-6-git-send-email-matt@console-pimps.org>
 <20131016141939.GA28684@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131016141939.GA28684@srcf.ucam.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Oct, at 03:19:39PM, Matthew Garrett wrote:
> On Wed, Oct 16, 2013 at 02:51:00PM +0100, Matt Fleming wrote:
> 
> > +	  Many EFI machines have buggy implementations of the UpdateCapsule()
> > +	  runtime service. This option will enable code that may not function
> > +	  correctly with your firmware.
> 
> Where by "May not function correctly" you mean "May crash the system"? 

Bingo.

> I'm a little uneasy having this run by default if enabled, even if it's 
> disabled by default in the config.

What would be the canonical way to enable this feature then? Have a file
along the lines of /sys/kernel/debug/capsule_enable, where a user would
be required to,

  echo 1 > /sys/kernel/debug/capsule_enable

to turn on the functionality?

-- 
Matt Fleming, Intel Open Source Technology Center
