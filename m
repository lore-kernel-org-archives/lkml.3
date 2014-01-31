Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932450AbaAaNyA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 08:54:00 -0500
Received: from relay2.sgi.com ([192.48.179.30]:43768 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932383AbaAaNx7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 08:53:59 -0500
Date: Fri, 31 Jan 2014 07:53:55 -0600
From: Russ Anderson <rja@sgi.com>
To: Matt Fleming <matt@console-pimps.org>
Cc: Alex Thorlton <athorlton@sgi.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        linux-efi@vger.kernel.org
Subject: Re: [BUG] Linux 3.14 fails to boot with new EFI changes
Message-ID: <20140131135355.GB22498@sgi.com>
Reply-To: Russ Anderson <rja@sgi.com>
References: <20140124184842.GD11788@pd.tnic>
 <20140124191709.GT18196@sgi.com>
 <20140127222129.GK6839@pd.tnic>
 <20140128110552.GA815@pd.tnic>
 <20140128200754.GZ18196@sgi.com>
 <20140128225905.GN815@pd.tnic>
 <20140128234036.GB18196@sgi.com>
 <20140129141822.GC24887@pd.tnic>
 <20140130221950.GJ3105@sgi.com>
 <20140131080428.GA29136@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140131080428.GA29136@console-pimps.org>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 31, 2014 at 08:04:28AM +0000, Matt Fleming wrote:
> On Thu, 30 Jan, at 04:19:50PM, Alex Thorlton wrote:
> > Re-adding lkml.
>  
> Also add linux-efi.
> 
> > The quick answer is I think it is a virtual address, because
> > it does not work in physical mode.  If you ever see "virtefi"
> > on the RHEL bootline it is because RH switched the default
> > to physical mode, which caused UV to not boot.  "virtefi"
> > forced it back to virtual mode.
> 
> Do you have details of the failure, links to bug reports? Is it a
> limitation of the firmware?

That was a non-upstream regression in the distro kernel.  The
3.13 community kernel was boots fine.  The current problem is a
regression introduced in this merge window which needs to be fixed.


-- 
Russ Anderson,  Kernel and Performance Software Team Manager
SGI - Silicon Graphics Inc          rja@sgi.com
