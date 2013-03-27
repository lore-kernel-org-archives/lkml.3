Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751728Ab3C0EUm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 00:20:42 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:37067 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750859Ab3C0EUk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 00:20:40 -0400
X-Sasl-enc: oKxSKyVjpy0RSBHMPsWb8PjcswuLaaR9vqXl96YPZdrb 1364358039
Date: Tue, 26 Mar 2013 21:20:38 -0700
From: Greg KH <greg@kroah.com>
To: Ming Lei <tom.leiming@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Johan Hovold <jhovold@gmail.com>
Subject: Re: linux-next: build failure after merge of the usb tree
Message-ID: <20130327042038.GB21615@kroah.com>
References: <20130327144134.0809a21c09b45d20a1fe480d@canb.auug.org.au>
 <CACVXFVPM6qbG2zdDE7apfyKf5mtnEZ2uQNHQTcFNVQ+SPBtbRA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACVXFVPM6qbG2zdDE7apfyKf5mtnEZ2uQNHQTcFNVQ+SPBtbRA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 27, 2013 at 11:51:41AM +0800, Ming Lei wrote:
> Hi,
> 
> On Wed, Mar 27, 2013 at 11:41 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> >
> >
> > I have reverted the commit from usb.current on the assumption that the
> > problem it solves has been, or will be, solved some other way.
> 
> The commit is needed in 3.9 linus tree and stable tree,  but for next
> tree or 3.10,
> a revert commit is required.
> 
> We know it is a problem, sorry, :-(

Yeah, sorry about that, I'll fix this up tomorrow when I merge the trees
together and resolve the conflict.

greg k-h
