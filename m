Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755774AbaBUWiA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 17:38:00 -0500
Received: from mga02.intel.com ([134.134.136.20]:49931 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755636AbaBUWh6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 17:37:58 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,521,1389772800"; 
   d="scan'208";a="459694903"
Date: Fri, 21 Feb 2014 14:37:56 -0800
From: Andi Kleen <ak@linux.intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-tip-commits@vger.kernel.org, Joe Mario <jmario@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>, mingo@kernel.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de
Subject: Re: [tip:x86/asmlinkage] lto: Handle LTO common symbols in module
 loader
Message-ID: <20140221223756.GF12219@tassilo.jf.intel.com>
References: <1391846481-31491-5-git-send-email-ak@linux.intel.com>
 <tip-80375980f1608f43b47abc2671456b23ec68c434@git.kernel.org>
 <87ios99y6u.fsf@rustcorp.com.au>
 <5307A503.1080605@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5307A503.1080605@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >>  		case SHN_COMMON:
> >> +			/* Ignore common symbols */
> >> +			if (!strncmp(name, "__gnu_lto", 9))
> >> +				break;
> >> +
> >>  			/* We compiled with -fno-common.  These are not
> > 
> > /* Ignore common symbols */ is so bad, it's not even wrong.
> > 
> 
> Joe, Andi, could one of you submit an incremental patch to clean up this
> comment?

You can just remove the patch. It was only needed for fat LTO,
which I stopped supporting.

-Andi
