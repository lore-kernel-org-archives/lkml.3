Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755153AbaJNCF4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 22:05:56 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36195 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754807AbaJNCFg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 22:05:36 -0400
Date: Tue, 14 Oct 2014 04:04:33 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Joe Perches <joe@perches.com>
Cc: DaeSeok Youn <daeseok.youn@gmail.com>, devel <devel@driverdev.osuosl.org>,
        driverdev-devel@linuxdriverproject.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Lidza Louina <lidza.louina@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH] staging: dgap: re-arrange functions for removing forward
 declarations.
Message-ID: <20141014020433.GA25433@kroah.com>
References: <20141013023425.GA15452@devel>
 <20141013032544.GA26646@kroah.com>
 <CAHb8M2A5e2akETQoWS6WfNJjUqhyu4ptfTMs9HLYgbw8XRR-Ww@mail.gmail.com>
 <1413212198.1287.9.camel@joe-AO725>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1413212198.1287.9.camel@joe-AO725>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 13, 2014 at 07:56:38AM -0700, Joe Perches wrote:
> On Mon, 2014-10-13 at 17:01 +0900, DaeSeok Youn wrote:
> > Hi,
> > 
> > 2014-10-13 12:25 GMT+09:00 Greg KH <gregkh@linuxfoundation.org>:
> > > On Mon, Oct 13, 2014 at 11:34:25AM +0900, Daeseok Youn wrote:
> > >> Re-arrange the functions for removing forward declarations.
> > >>
> > >> Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
> > >> ---
> > >> This patch has too many changes for re-arranging the functions.
> > >> So I wonder that I should break this up into smaller patches.
> > >
> > > Are the .o files identical before and after this patch?  If so, it's
> > > fine.
> > Ok. I will check for that.
> 
> The .o files shouldn't be identical after function reordering.

Hm, they might be the same size, but I can see how on some
architectures (like ppc) how that would not be the case, you are right.

Isn't there an "objdiff" program or something like that which might help
in validating that nothing "changed" in the source for type of patch
that just moves functions around in a file.

thanks,

greg k-h
