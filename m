Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933266AbaE2O4b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 10:56:31 -0400
Received: from mga03.intel.com ([143.182.124.21]:31419 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932521AbaE2O4a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 10:56:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,934,1392192000"; 
   d="scan'208";a="438583360"
Date: Thu, 29 May 2014 17:56:25 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Miklos Szeredi <mszeredi@suse.cz>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: fs/dcache.c - BUG: soft lockup - CPU#5 stuck for 22s!
 [systemd-udevd:1667]
Message-ID: <20140529145625.GA6263@lahna.fi.intel.com>
References: <20140528115701.GY18016@ZenIV.linux.org.uk>
 <20140528131136.GA1643@lahna.fi.intel.com>
 <20140528141937.GZ18016@ZenIV.linux.org.uk>
 <20140528183954.GA18016@ZenIV.linux.org.uk>
 <20140529031149.GE18016@ZenIV.linux.org.uk>
 <20140529035233.GF18016@ZenIV.linux.org.uk>
 <20140529053444.GI18016@ZenIV.linux.org.uk>
 <20140529105107.GB1938@lahna.fi.intel.com>
 <20140529110439.GA2006@lahna.fi.intel.com>
 <20140529133036.GJ18016@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140529133036.GJ18016@ZenIV.linux.org.uk>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 29, 2014 at 02:30:36PM +0100, Al Viro wrote:
> On Thu, May 29, 2014 at 02:04:39PM +0300, Mika Westerberg wrote:
> 
> > With your both patches applied the problem is gone :-)
> > 
> > I did 20 plug/unplugs, rebooted the machine and another 20 plug/unplugs
> > and didn't see the livelock at once.
> 
> Great...  OK, saner splitup of that sucker (equivalent to combination of
> these two patches) is in vfs.git#for-linus.
> 
> Review and testing would be very welcome.

I'll re-test that branch first thing tomorrow morning (currently at home
and the machine where this reproduces is my work desktop).
