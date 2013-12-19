Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754220Ab3LSRYU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 12:24:20 -0500
Received: from mail-qa0-f45.google.com ([209.85.216.45]:48709 "EHLO
	mail-qa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753900Ab3LSRYQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 12:24:16 -0500
Date: Thu, 19 Dec 2013 12:24:12 -0500
From: Tejun Heo <tj@kernel.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Jens Axboe <axboe@kernel.dk>, tomaz.solc@tablix.org,
        aaron.lu@intel.com, linux-kernel@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Fengguang Wu <fengguang.wu@intel.com>
Subject: Re: [PATCH v3] libata, freezer: avoid block device removal while
 system is frozen
Message-ID: <20131219172412.GA22725@htj.dyndns.org>
References: <20131213174932.GA27070@htj.dyndns.org>
 <20131217125042.GF29989@htj.dyndns.org>
 <20131218120732.GB4324@htj.dyndns.org>
 <4198915.dARHSKzc5x@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4198915.dARHSKzc5x@vostro.rjw.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Dec 18, 2013 at 11:08:41PM +0100, Rafael J. Wysocki wrote:
> > This is something fundamentally broken.  For now,
> > implement a funny workaround in libata - just avoid doing block device
> > hot[un]plug while the system is frozen.  Kernel engineering at its
> > finest.  :(
> > 
> > v2: Add EXPORT_SYMBOL_GPL(pm_freezing) for cases where libata is built
> >     as a module.
> > 
> > v3: Comment updated and polling interval changed to 10ms as suggested
> >     by Rafael.
> 
> This one is fine by my FWIW.

Applied to libata/for-3.13-fixes.  I liberally added your reviewed-by
from the above response.  Please let me know if I should remove it.
I'll push it out to Linus after it spends a couple days in -next.

Thanks!

-- 
tejun
