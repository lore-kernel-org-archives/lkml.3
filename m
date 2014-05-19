Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751975AbaESWW7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 18:22:59 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:49924 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751514AbaESWW6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 18:22:58 -0400
Date: Mon, 19 May 2014 15:22:48 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Jake Edge <jake@lwn.net>
Cc: Anton Saraev <antonysaraev@gmail.com>, devel@driverdev.osuosl.org,
        jason@lakedaemon.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 06/06] staging: crypto: skein: rename files
Message-ID: <20140519222248.GA9931@kroah.com>
References: <cover.1399675444.git.antonysaraev@gmail.com>
 <abebc2187151826190d6f664acc654241b352ffa.1399675444.git.antonysaraev@gmail.com>
 <dad2a43d54d03ba2b4fae9136331df060c48154c.1399675444.git.antonysaraev@gmail.com>
 <cba3f6453b416ea04b03ad2d165f600e3e39f152.1399675444.git.antonysaraev@gmail.com>
 <b4028782c333773298763d58e14753067c6ae745.1399675444.git.antonysaraev@gmail.com>
 <2eac124c6a3815c72e91679c8cde729af712bb74.1399675445.git.antonysaraev@gmail.com>
 <a5204985750d7adf9b20752f889fbf2a2147de94.1399675445.git.antonysaraev@gmail.com>
 <20140519074510.74e622fd@chukar.edge2.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140519074510.74e622fd@chukar.edge2.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 19, 2014 at 07:45:10AM -0600, Jake Edge wrote:
> On Mon, 19 May 2014 12:09:59 +0400 Anton Saraev wrote:
> 
> > --- a/drivers/staging/skein/Makefile
> > +++ b/drivers/staging/skein/Makefile
> > @@ -4,10 +4,10 @@
> >  subdir-ccflags-y := -I$(src)/include/
> 
> as part of the rearranging of files, I think you want to get rid of
> this include directory, move the files up to the main directory and
> include them as "skein.h" (rather than <skein.h>).
> 
> Then this line can be removed from the Makefile.

I agree, I'll not take this last one in the series.

thanks,

greg k-h
