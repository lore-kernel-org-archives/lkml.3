Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752631Ab3HAH0I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 03:26:08 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41482 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752437Ab3HAH0D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 03:26:03 -0400
Date: Wed, 31 Jul 2013 17:41:49 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Xiong Zhou <jencce.kernel@gmail.com>
Cc: Peng Tao <bergwolf@gmail.com>, Andreas Dilger <andreas.dilger@intel.com>,
        Paul Bolle <pebolle@tiscali.nl>, Jiri Kosina <trivial@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>
Subject: Re: [PATCH v2] staging/lustre: lloop depends on BLOCK
Message-ID: <20130801004149.GA30696@kroah.com>
References: <alpine.DEB.2.02.1307300827010.2625@M2420>
 <CA+a=Yy4FAOhKkwgzuCj-rtd9rE2jc8WOf=E8OMQ=o=JUrGgW1w@mail.gmail.com>
 <alpine.DEB.2.02.1307311028001.25194@M2420>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1307311028001.25194@M2420>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 31, 2013 at 10:30:41AM +0800, Xiong Zhou wrote:
> From: Xiong Zhou <jencce.kernel@gmail.com>
> 
> First version of this patch makes LUSTRE_FS depends on BLOCK.  Second
> version makes only lloop depends on BLOCK with a config option for this
> dependence, and remove unnecessary jdb header files which depends on
> BLOCK.
> 
> This version removes the wrapper ll_unregister_blkdev which depends on
> BLOCK in header and just call unregister_blkdev in lloop.c based on Peng
> Tao's comment.

This isn't all needed in the patch changelog info, just say what it
does.

Also, it doesn't apply for some reason, care to refresh this against my
latest tree and resend?

thanks,

greg k-h
