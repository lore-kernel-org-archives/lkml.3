Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753406AbaHDXi2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 19:38:28 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34887 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753380AbaHDXi0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 19:38:26 -0400
Date: Mon, 4 Aug 2014 16:38:26 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: DaeSeok Youn <daeseok.youn@gmail.com>
Cc: Mark Hounschell <markh@compro.net>, devel <devel@driverdev.osuosl.org>,
        Lidza Louina <lidza.louina@gmail.com>,
        driverdev-devel@linuxdriverproject.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH V2] staging: dgap: introduce dgap_cleanup_nodes()
Message-ID: <20140804233826.GA20456@kroah.com>
References: <166070137.57941.1406779444750.JavaMail.root@mx2.compro.net>
 <53DA3A2D.90403@compro.net>
 <1598413764.80217.1406848485858.JavaMail.root@mx2.compro.net>
 <53DF7F34.5030201@compro.net>
 <CAHb8M2DkfnkrsjLciSvS=_0GM4wn1dC33ExUWS7nYG=mnNH+Xg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHb8M2DkfnkrsjLciSvS=_0GM4wn1dC33ExUWS7nYG=mnNH+Xg@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 05, 2014 at 08:33:16AM +0900, DaeSeok Youn wrote:
> Hi, Mark and Greg.
> 
> Thanks for testing. :-)
> 
> Greg, is this patch possible to merge to your staging tree?
> Please check for me.
> patch : https://lkml.org/lkml/2014/7/31/2

It's the middle of the merge window, I can't do anything until after
3.17-rc1 is out.  So wait until then, I'll pick up the patch at that
point in time, it's still in my "to-apply" queue.

thanks,

greg k-h
