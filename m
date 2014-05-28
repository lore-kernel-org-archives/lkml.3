Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752528AbaE1Mle (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 08:41:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52236 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752068AbaE1Mlc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 08:41:32 -0400
Date: Wed, 28 May 2014 08:40:29 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Dave Young <dyoung@redhat.com>
Cc: matt.fleming@intel.com, bp@alien8.de, linux-kernel@vger.kernel.org,
        linux-efi@vger.kernel.org
Subject: Re: [PATCH] export efi.flags to sysfs
Message-ID: <20140528124029.GF14863@redhat.com>
References: <20140526083935.GA19682@dhcp-16-198.nay.redhat.com>
 <20140527133411.GG10994@redhat.com>
 <20140528021359.GC2820@darkstar.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140528021359.GC2820@darkstar.nay.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 28, 2014 at 10:13:59AM +0800, Dave Young wrote:
> On 05/27/14 at 09:34am, Vivek Goyal wrote:
> > On Mon, May 26, 2014 at 04:39:35PM +0800, Dave Young wrote:
> > > 
> > > For efi=old_map and any old_map quirks like SGI UV in current
> > > tree kexec/kdump will fail because it depends on the new 1:1 mapping.
> > > 
> > > Thus export the mapping method to sysfs so kexec tools can switch
> > > to original way to boot.
> > > 
> > > Since we have efi.flags for all efi facilities so let's just export the
> > > efi.flags itself, it maybe useful for other arches and use cases.
> > > 
> > 
> > Does it require any documentation in Documentation/ABI/..
> 
> Yes, it's necessary. Will do in next version.
> 
> I'm still discussing with Matt, exporting efi.flags seems not a good way
> because they are more internal interfaces. 
> 
> Probably I should export only a file 'old_map' instead.

How does /sys/firmware/efi/runtime-map/* look like with old mapping? Can't
we look at it and figure out if it is 1:1 or not.

Thanks
Vivek
