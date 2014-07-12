Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754133AbaGLCTD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 22:19:03 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43229 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752586AbaGLCTB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 22:19:01 -0400
Date: Fri, 11 Jul 2014 19:23:29 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Joe Perches <joe@perches.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, devel@driverdev.osuosl.org,
        kernel-janitors <kernel-janitors@vger.kernel.org>,
        kernelnewbies@kernelnewbies.org, LKML <linux-kernel@vger.kernel.org>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH] checkpatch: Remove unnecessary + after {8,8}
Message-ID: <20140712022329.GA29482@kroah.com>
References: <1405128087.6751.12.camel@joe-AO725>
 <20140712013927.GA30781@kroah.com>
 <1405129612.6751.24.camel@joe-AO725>
 <20140712020114.GA12301@kroah.com>
 <20140712020520.GA18611@kroah.com>
 <1405130970.6751.37.camel@joe-AO725>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1405130970.6751.37.camel@joe-AO725>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 11, 2014 at 07:09:30PM -0700, Joe Perches wrote:
> There's a useless "+" use that needs to be removed as perl 5.20
> emits a "Useless use of greediness modifier '+'" message each
> time it's hit.
> 
> Reported-by: Greg KH <gregkh@linuxfoundation.org>
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
> On Fri, 2014-07-11 at 19:05 -0700, Greg KH wrote:
> > Ok, with linux-next I get the same thing:
> 
> Thanks Greg.

Very nice, thanks for this:

Tested-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
