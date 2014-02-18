Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752181AbaBRSwT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 13:52:19 -0500
Received: from one.firstfloor.org ([193.170.194.197]:55389 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751823AbaBRSwR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 13:52:17 -0500
Date: Tue, 18 Feb 2014 19:52:16 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        sam@ravnborg.org, x86@kernel.org, linux-kbuild@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>, rusty@rustcorp.com.au
Subject: Re: [PATCH 19/20] lto, module: Warn about modules that are not
 fully LTOed
Message-ID: <20140218185216.GC22728@two.firstfloor.org>
References: <1392733738-8290-1-git-send-email-andi@firstfloor.org>
 <1392733738-8290-20-git-send-email-andi@firstfloor.org>
 <20140218145039.GA5339@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140218145039.GA5339@phenom.dumpdata.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 18, 2014 at 09:50:39AM -0500, Konrad Rzeszutek Wilk wrote:
> On Tue, Feb 18, 2014 at 03:28:57PM +0100, Andi Kleen wrote:
> > From: Andi Kleen <ak@linux.intel.com>
> > 
> > When __gnu_lto_* is present that means that the module hasn't run with
> > LTO yet.
> 
> The title says 'warn' but this is not a warning just information.
> 
> Can you actually build modules against the kernel with different compiler
> options? I thought it would complain when trying to load about some
> form of mismatch?

Sure it has worked forever (I think the only reason we still check
compiler versions was some ancient long obsolete ABI problem)

LTO is also fully ABI compatible.

Hmm I think this patch can be actually removed now because I default
to slim LTO, and with that it wouldn't even load if this happens.
I'll remove it.

-Andi
