Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932412AbaE3GRE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 02:17:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28112 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754750AbaE3GQW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 02:16:22 -0400
Date: Fri, 30 May 2014 14:17:40 +0800
From: Dave Young <dyoung@redhat.com>
To: Simon Horman <horms@verge.net.au>
Cc: matt.fleming@intel.com, bp@alien8.de, linux-kernel@vger.kernel.org,
        linux-efi@vger.kernel.org, vgoyal@redhat.com
Subject: Re: [PATCH]x86 efi: do not export efi runtime map in case old map
Message-ID: <20140530061740.GC2187@darkstar.nay.redhat.com>
References: <20140530032010.GA29906@dhcp-16-198.nay.redhat.com>
 <20140530055447.GB2187@darkstar.nay.redhat.com>
 <20140530060810.GA31868@verge.net.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140530060810.GA31868@verge.net.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/30/14 at 03:08pm, Simon Horman wrote:
> On Fri, May 30, 2014 at 01:54:47PM +0800, Dave Young wrote:
> > Ccing Simon.
> > 
> > Simon, appologize for not ccing you about this kernel patch. I see you have
> > applied the userspace patch for checking sysfs runtime existance.
> > 
> > The userspace patch depends on this patch but it is not harmful even without
> > this kernel patch. So applying the userspace patch before this one is still
> > safe.
> 
> Thanks, I understand.
> 
> If the kernel side ends up being rejected or modified please
> send an update for kexec-tools accordingly.

Sure, will do

Thanks
Dave
