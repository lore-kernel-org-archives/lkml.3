Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753368Ab3LRKbS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 05:31:18 -0500
Received: from arkanian.console-pimps.org ([212.110.184.194]:54670 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752534Ab3LRKbR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 05:31:17 -0500
Date: Wed, 18 Dec 2013 10:31:00 +0000
From: Matt Fleming <matt@console-pimps.org>
To: Dave Young <dyoung@redhat.com>
Cc: matt.fleming@intel.com, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, x86@kernel.org, linux-efi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] efi earlyprintk fix
Message-ID: <20131218103100.GD3145@console-pimps.org>
References: <20131103121647.GA4770@dhcp-16-126.nay.redhat.com>
 <20131104103739.GD21688@console-pimps.org>
 <20131104125853.GB5118@dhcp-16-126.nay.redhat.com>
 <20131218095256.GA3752@dhcp-16-126.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131218095256.GA3752@dhcp-16-126.nay.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Dec, at 05:52:56PM, Dave Young wrote:
> > It's my laptop Thinkpad T420, the screen scolls very fast, I use boot_delay=500
> > to verify it with my patch for moving boot_delay param an early param.
> > 
> > Even without boot_delay, there's always a line at bottom with only the prefix:
> > "efi:"
> 
> Update about this issue:
> With latest mainline tree + efi runtime patchset, above problem does not happen
> any more (with and without boot_delay).

Thanks for the update.

-- 
Matt Fleming, Intel Open Source Technology Center
