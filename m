Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754801AbaDPHFZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 03:05:25 -0400
Received: from mail-lb0-f169.google.com ([209.85.217.169]:52813 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754267AbaDPHFX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 03:05:23 -0400
Date: Wed, 16 Apr 2014 11:05:20 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, hughd@google.com,
        xemul@parallels.com, Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: Re: [patch 4/4] mm: Clear VM_SOFTDIRTY flag inside clear_refs_write
 instead of clear_soft_dirty
Message-ID: <20140416070520.GX23983@moon>
References: <20140324122838.490106581@openvz.org>
 <20140324125926.204897920@openvz.org>
 <20140415110654.4dd9a97c216e2689316fa448@linux-foundation.org>
 <20140415182935.GR23983@moon>
 <20140415114449.c8732a56f9974c2819e4541a@linux-foundation.org>
 <20140415184851.GS23983@moon>
 <20140415115219.2676d2107b3f6b0dd5573062@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140415115219.2676d2107b3f6b0dd5573062@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 15, 2014 at 11:52:19AM -0700, Andrew Morton wrote:
> > > 
> > > -mm isn't in -next at present.  I'll get a release done later today for
> > > tomorrow's -next.
> > 
> > OK. Could you please remind me the place I could fetch the patchwalk series from?
> 
> http://ozlabs.org/~akpm/mmots/
> 
> > (or better to wait until -mm get merged into -next?)
> 
> That's probably simpler.

I've fetched -next tree and updated patch looks good, thanks Andrew!
