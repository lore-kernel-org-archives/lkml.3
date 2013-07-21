Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755853Ab3GUPuU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jul 2013 11:50:20 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36416 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755280Ab3GUPuS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jul 2013 11:50:18 -0400
Date: Sun, 21 Jul 2013 08:50:31 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Willy Tarreau <w@1wt.eu>
Cc: Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, stable@vger.kernel.org,
        Nicolas Pitre <nico@linaro.org>
Subject: Re: [ 00/72] 3.10.2-stable review
Message-ID: <20130721155031.GJ16598@kroah.com>
References: <20130719052559.852627424@linuxfoundation.org>
 <20130721075639.GB1860@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130721075639.GB1860@1wt.eu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 21, 2013 at 09:56:39AM +0200, Willy Tarreau wrote:
> Hi Greg,
> 
> On Thu, Jul 18, 2013 at 10:25:17PM -0700, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 3.10.2 release.
> > There are 72 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sun Jul 21 05:25:08 UTC 2013.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.10.2-rc1.gz
> > and the diffstat can be found below.
> 
> As I saw a number of ARM fixes, I gave it a try on an Armada XP-GP
> board. I observed no regression compared to 3.10.0. However I still
> need to apply the following patch otherwise it hangs during the boot
> process :
> 
>    faefd550c4 ARM: 7722/1: zImage: Convert 32bits memory size and address from ATAG to 64bits DTB
> 
> So Gregory, Russell, does this patch qualify for stable, and if so,
> could it be proposed in a later version ?

Thanks for testing and letting me know.  I have no objection to adding
the above patch to the 3.10-stable releases, if the others agree.

thanks,

greg k-h
