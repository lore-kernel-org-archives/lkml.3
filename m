Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754061AbaCEGaw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 01:30:52 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:46457 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752099AbaCEGav (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 01:30:51 -0500
Date: Tue, 4 Mar 2014 22:31:11 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Jon Ringle <jringle@gridpoint.com>
Cc: "Ringle, Jonathan" <Jonathan.Ringle@gridpoint.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Add option to build with -O3
Message-ID: <20140305063111.GA8816@kroah.com>
References: <1393977709-9809-1-git-send-email-jringle@gridpoint.com>
 <20140305050927.GA8534@kroah.com>
 <alpine.DEB.2.02.1403050019300.22601@jringle-ubuntu>
 <20140305060815.GA3432@kroah.com>
 <alpine.DEB.2.02.1403050111490.24331@jringle-ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1403050111490.24331@jringle-ubuntu>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 05, 2014 at 01:19:17AM -0500, Jon Ringle wrote:
> 
> 
> On Wed, 5 Mar 2014, Greg KH wrote:
> 
> > On Wed, Mar 05, 2014 at 12:37:56AM -0500, Jon Ringle wrote:
> > > The information contained in this transmission may contain confidential information.  If the reader of this message is not the intended recipient, you are hereby notified that any review, dissemination, distribution or duplication of this communication is strictly prohibited.  If you are not the intended recipient, please contact the sender by reply email and destroy all copies of the original message.
> >
> > Because of this footer, I must destroy this message, kernel development
> > is not confidental.
> >
> 
> Obviously, this is a footer that is not added by me, but rather the mail
> server I am sending this message through. Besides, the footer indates it
> "may contain confidential information". The key word being *may*. Of
> course kernel development is never confidential and the content of any
> transmission done to the lkml is of public record. You and anyone who
> cares to read/comment this message on lkml is indeed the inteded
> recipient, therefore there is no need to destroy this message :)

But how do I know for sure that there isn't anything confidential in it?

> I sure hope your response was just in jest :)

Sadly, no, I have been advised that I am not supposed to respond to
messages with footers like that, and I am not allowed to take patches
with them either.

Now, I'm ignoring the first part (responding) to help you learn why your
patches will proabably always be ignored, please work to remove that
from your email server.

good luck,

greg k-h
