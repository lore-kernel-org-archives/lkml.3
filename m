Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752191Ab3FXKcz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 06:32:55 -0400
Received: from 8bytes.org ([85.214.48.195]:39142 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751621Ab3FXKci (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 06:32:38 -0400
Date: Mon, 24 Jun 2013 12:32:34 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Joe Perches <joe@perches.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        iommu@lists.linux-foundation.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V2] iommu: Use %pa and %zx instead of casting
Message-ID: <20130624103233.GA2778@8bytes.org>
References: <20130621153331.2881.35589.stgit@bling.home>
 <20130623114930.GA2557@8bytes.org>
 <1372009427.3137.54.camel@joe-AO722>
 <CAMuHMdWb4WK9ZuJ-vwdywgDSSbZTnnS1emF02VzrUgrSt5VKsg@mail.gmail.com>
 <1372015744.3137.74.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1372015744.3137.74.camel@joe-AO722>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Mon Jun 24 12:32:36 2013
X-DSPAM-Confidence: 0.9988
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 51c8204420867696810140
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 23, 2013 at 12:29:04PM -0700, Joe Perches wrote:
> printk supports using %pa for phys_addr_t and
> %zx for size_t so use those instead of %lx and
> casts to unsigned long.
> 
> Other miscellaneous changes around this:
> 
> Always use 0x%zx for size instead of one use of decimal.
> Coalesce format and align arguments.
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Applied to core, thanks.


