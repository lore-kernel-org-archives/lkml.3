Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755016AbaIBTEw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 15:04:52 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:56287 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754426AbaIBTEu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 15:04:50 -0400
Date: Tue, 2 Sep 2014 12:04:45 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: linux-next: Tree for Aug 23
Message-ID: <20140902190445.GB8829@roeck-us.net>
References: <20140823080422.7895575c@canb.auug.org.au>
 <20140825045741.GA29723@roeck-us.net>
 <20140901155804.GT27892@worktop.ger.corp.intel.com>
 <5404A2F2.3090908@roeck-us.net>
 <20140901190438.GB5806@worktop.ger.corp.intel.com>
 <20140902094016.GD31157@worktop.ger.corp.intel.com>
 <20140902095553.GE31157@worktop.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140902095553.GE31157@worktop.ger.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 02, 2014 at 11:55:53AM +0200, Peter Zijlstra wrote:
> On Tue, Sep 02, 2014 at 11:40:16AM +0200, Peter Zijlstra wrote:
> > On Mon, Sep 01, 2014 at 09:04:38PM +0200, Peter Zijlstra wrote:
> > > On Mon, Sep 01, 2014 at 09:46:42AM -0700, Guenter Roeck wrote:
> > > > Yes, the problem is still seen in next-140829. See qemu test results at
> > > > http://server.roeck-us.net:8010/builders.
> > > > 
> > > > I provided sparc64 images at http://server.roeck-us.net/qemu/sparc64/.
> > > > The README file includes instructions on how to run the image in qemu
> > > > and how to build a kernel.
> > > > 
> > > > I can do the same for mips and mips64 if needed; let me know.
> > > 
> > > Thanks, that's enough to get started.
> > 
> > This makes sparc64 go again, silly oversight indeed.
> > 
> 
> The same for mips. Can you either provide the mips image or verify this works?
> 
Still fails, unfortunately.

I provided qemu images and instructions as follows.
	http://server.roeck-us.net/qemu/mipsel/		MIPS 32 bit, little endian
	http://server.roeck-us.net/qemu/mips64el/	MIPS 64 bit, little endian

Let me know if you also need big endian images.

Thanks,
Guenter
