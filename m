Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754609Ab3GARU0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 13:20:26 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:47120 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751889Ab3GARUZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 13:20:25 -0400
Date: Mon, 1 Jul 2013 10:20:24 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Michal Simek <monstr@monstr.eu>
Cc: Pavel Machek <pavel@ucw.cz>, Michal Simek <michal.simek@xilinx.com>,
        linux-kernel@vger.kernel.org, "Hans J. Koch" <hjk@hansjkoch.de>
Subject: Re: [PATCH v3 2/2] uio: Remove uio_pdrv and use uio_pdrv_genirq
 instead
Message-ID: <20130701172024.GA25891@kroah.com>
References: <03c8973cc1e9efcd203e4d95d2dd9469afbcb39b.1372240320.git.michal.simek@xilinx.com>
 <771234ccdcd59f6918deb4a8690b4b435a9da556.1372240320.git.michal.simek@xilinx.com>
 <20130626231706.GA13166@amd.pavel.ucw.cz>
 <51D12DEA.1010700@monstr.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51D12DEA.1010700@monstr.eu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 01, 2013 at 09:21:14AM +0200, Michal Simek wrote:
> Hi Greg,
> 
> On 06/27/2013 01:17 AM, Pavel Machek wrote:
> > On Wed 2013-06-26 11:52:12, Michal Simek wrote:
> >> The patch "UIO: fix uio_pdrv_genirq with device tree but no interrupt"
> >> (sha1: e3a3c3a205554e564751cd9c0276b2af813d7a92)
> >> add support to use this driver with no interrupts.
> >> uio_pdrv_genirq also supports device-tree binding
> >> which is not available in uio_pdrv.
> >>
> >> That's why this uio_pdrv driver can be just removed.
> >>
> >> Signed-off-by: Michal Simek <michal.simek@xilinx.com>
> > 
> > Reviewed-by: Pavel Machek <pavel@denx.de>
> 
> I see 3.10 was tagged.
> Are you going to add this patch to your char-misc tree?

I will consider it after 3.11-rc1 is out, it came too late in the 3.11
merge cycle for me to take it.

thanks,

greg k-h
