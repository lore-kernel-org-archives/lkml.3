Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752219AbbARDJx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2015 22:09:53 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57566 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751401AbbARDJw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2015 22:09:52 -0500
Date: Sat, 17 Jan 2015 19:07:48 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Andrew Milkovich <amilkovich@gmail.com>
Cc: benjamin.romer@unisys.com, david.kershner@unisys.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: unisys: virtpci: fixed coding style errors
Message-ID: <20150118030748.GA31575@kroah.com>
References: <1421470690-9534-1-git-send-email-amilkovich@gmail.com>
 <20150118002235.GA10241@kroah.com>
 <20150118030141.GA1937@zenbook.hsd1.ca.comcast.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150118030141.GA1937@zenbook.hsd1.ca.comcast.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 17, 2015 at 07:01:41PM -0800, Andrew Milkovich wrote:
> Hi,
> 
> On Sat, Jan 17, 2015 at 04:22:35PM -0800, Greg KH wrote:
> > On Fri, Jan 16, 2015 at 08:58:10PM -0800, Andrew Milkovich wrote:
> > > Fixed coding style errors per checkpatch.pl. Inline comments removed; chanptr
> > > comment is implied by the first argument being the channel. No parent bus
> > > comment is already understood by the argument being NULL.
> > > 
> > > Signed-off-by: Andrew Milkovich <amilkovich@gmail.com>
> > > ---
> > >  drivers/staging/unisys/virtpci/virtpci.c | 24 ++++++++----------------
> > >  1 file changed, 8 insertions(+), 16 deletions(-)
> > 
> > This doesn't apply to my staging-testing branch at all, sorry.
> > 
> > greg k-h
> 
> Processing the patch with 'git apply' complains about a corruption; this is due
> to the fact that I ran cleanfile on the patch. The checkpatch.pl script was
> giving errors about trailing whitespace. I ran cleanpatch, errors still showed
> up, I ran cleanfile and it passed.
> 
> Using 'patch -p1 < patchname' seems to work.

Doesn't work for me, try it against the branch above, I think it was due
to other changes in this driver in my tree.

If not, just resend, maybe I messed something up on my end, it has been
known to happen :)

thanks,

greg k-h
