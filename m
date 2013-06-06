Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752537Ab3FFP2q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 11:28:46 -0400
Received: from relay2.sgi.com ([192.48.179.30]:46101 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751353Ab3FFP2p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 11:28:45 -0400
Date: Thu, 6 Jun 2013 10:28:43 -0500
From: Russ Anderson <rja@sgi.com>
To: Matt Fleming <matt@console-pimps.org>
Cc: joeyli <jlee@suse.com>, Matthew Garrett <matthew.garrett@nebula.com>,
        "Fleming, Matt" <matt.fleming@intel.com>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "bp@alien8.de" <bp@alien8.de>, "jkosina@suse.cz" <jkosina@suse.cz>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "hpa@linux.intel.com" <hpa@linux.intel.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "oneukum@suse.de" <oneukum@suse.de>
Subject: Re: [PATCH] Modify UEFI anti-bricking code
Message-ID: <20130606152843.GB10393@sgi.com>
Reply-To: Russ Anderson <rja@sgi.com>
References: <1370316933.30695.7.camel@linux-s257.site> <CAL01qptzxe5L6Vq+nBZLq+bQNxbe_i_2OdKMNJGZQDfMihaHOw@mail.gmail.com> <1370444007.6315.32.camel@x230.lan> <20130605155904.GC30420@console-pimps.org> <1370495110.6523.35.camel@linux-s257.site> <1370497321.6315.44.camel@x230.lan> <1370504426.6523.49.camel@linux-s257.site> <20130606092542.GE30420@console-pimps.org> <20130606144846.GA10393@sgi.com> <20130606150039.GL30420@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130606150039.GL30420@console-pimps.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 06, 2013 at 04:00:39PM +0100, Matt Fleming wrote:
> On Thu, 06 Jun, at 09:48:46AM, Russ Anderson wrote:
> > This looks like it will try to allocate more than the remaining size.
> > Is that intended?
> 
> Yes, the intention is to trigger garbage collection.

OK, if that's what it takes.  It just struck me as something
that would fail initial parameter checking in the bios,
before getting far enough to trigger garbage collection.

Since I really want the rest of this patch to go in, I'm certainly
not going to object.  :-)

Thanks,
-- 
Russ Anderson, OS RAS/Partitioning Project Lead  
SGI - Silicon Graphics Inc          rja@sgi.com
