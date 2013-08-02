Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755055Ab3HBDJ6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 23:09:58 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60516 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753019Ab3HBDJ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 23:09:56 -0400
Date: Fri, 2 Aug 2013 11:11:11 +0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Xiong Zhou <jencce.kernel@gmail.com>
Cc: "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        Paul Bolle <pebolle@tiscali.nl>, Jiri Kosina <trivial@kernel.org>,
        Peng Tao <bergwolf@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: Re: [PATCH v2] staging/lustre: lloop depends on BLOCK
Message-ID: <20130802031111.GA2329@kroah.com>
References: <alpine.DEB.2.02.1307300827010.2625@M2420>
 <CA+a=Yy4FAOhKkwgzuCj-rtd9rE2jc8WOf=E8OMQ=o=JUrGgW1w@mail.gmail.com>
 <alpine.DEB.2.02.1307311028001.25194@M2420>
 <20130801004149.GA30696@kroah.com>
 <alpine.DEB.2.02.1308021019220.8333@M2420>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.DEB.2.02.1308021019220.8333@M2420>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 02, 2013 at 10:20:28AM +0800, Xiong Zhou wrote:
> 
> 
> On Wed, 31 Jul 2013, Greg Kroah-Hartman wrote:
> 
> > On Wed, Jul 31, 2013 at 10:30:41AM +0800, Xiong Zhou wrote:
> > > From: Xiong Zhou <jencce.kernel@gmail.com>
> > > 
> > > First version of this patch makes LUSTRE_FS depends on BLOCK.  Second
> > > version makes only lloop depends on BLOCK with a config option for this
> > > dependence, and remove unnecessary jdb header files which depends on
> > > BLOCK.
> > > 
> > > This version removes the wrapper ll_unregister_blkdev which depends on
> > > BLOCK in header and just call unregister_blkdev in lloop.c based on Peng
> > > Tao's comment.
> > 
> > This isn't all needed in the patch changelog info, just say what it
> > does.
> > 
> > Also, it doesn't apply for some reason, care to refresh this against my
> > latest tree and resend?
> > 
> > thanks,
> > 
> > greg k-h
> > 
> 
> OK, this patch is based on the staging-next branch of your staging tree.
> 
> 
> From: Xiong Zhou <jencce.kernel@gmail.com>
> 
> Add a config option for llite/lloop in lustre driver, making it 
> depends on BLOCK to fix this better:
> drivers/staging/lustre/lustre/fid/../include/linux/lustre_compat25.h:117:2: 
> error: implicit declaration of function ‘unregister_blkdev’ 
> 
> Also, remove the wrapper ll_unregister_blkdev which depends on BLOCK in
> the header and just call unregister_blkdev in lloop.c based on Peng Tao's
> comment. Drop the redundant dependency on STAGING for LUSTRE_FS, remove 
> some unnecessary jdb header files which depends on BLOCK btw.
> 
> Signed-off-by: Xiong Zhou <jencce.kernel@gmail.com>
> Reviewed-by: Peng Tao <tao.peng@emc.com>

Please resend this so I don't have to edit the body of the email, and
the Subject: line as well.

Also, you have a bunch of trailing whitespace in your changelog
comments, are you sure you want/need that?

thanks,

greg k-h
