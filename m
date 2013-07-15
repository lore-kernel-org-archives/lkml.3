Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754610Ab3GOSmR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 14:42:17 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:48211 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753598Ab3GOSmQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 14:42:16 -0400
Date: Mon, 15 Jul 2013 11:40:30 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Joe Perches <joe@perches.com>
Cc: Peng Tao <bergwolf@gmail.com>, linux-kernel@vger.kernel.org,
        Fengguang Wu <fengguang.wu@intel.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: Re: [PATCH-v3 00/17] staging/lustre: fix various build issues
Message-ID: <20130715184030.GA17220@kroah.com>
References: <1373898440-14208-1-git-send-email-bergwolf@gmail.com>
 <1373908589.2062.18.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1373908589.2062.18.camel@joe-AO722>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 15, 2013 at 10:16:29AM -0700, Joe Perches wrote:
> On Mon, 2013-07-15 at 22:27 +0800, Peng Tao wrote:
> > Hi Greg,
> > 
> > Now that 3.11-rc1 is out, please consider queuing following patches to
> > fix various Lustre client build issues. I've verified that we can now
> > pass build on sparc/mips/s390/powerpc/x86, both 32bits and 64bits.
> 
> These patches apply to linus' current, but not to -next
> where other lustre patches have already been applied.

What trees are those in?  I have nothing in my staging-next branch right
now, so they didn't come from there, which is where I will be applying
this to.

thanks,

greg k-h
