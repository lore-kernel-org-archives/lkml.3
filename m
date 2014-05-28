Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932264AbaE1VLv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 17:11:51 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:43950 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751418AbaE1VLu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 17:11:50 -0400
X-Sasl-enc: uux+QQiAoHhTeF6ZT1crc/j2Txbgryi901K4pseXCerE 1401311507
Date: Wed, 28 May 2014 14:15:22 -0700
From: Greg KH <greg@kroah.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the final tree
Message-ID: <20140528211522.GA18268@kroah.com>
References: <20140528194629.0757af1b@canb.auug.org.au>
 <1401271041.28714.22.camel@x220>
 <1401272095.28714.30.camel@x220>
 <1401308488.6186.10.camel@x220>
 <20140528204232.GA8224@kroah.com>
 <1401310082.6186.16.camel@x220>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1401310082.6186.16.camel@x220>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 28, 2014 at 10:48:02PM +0200, Paul Bolle wrote:
> On Wed, 2014-05-28 at 13:42 -0700, Greg KH wrote:
> > Either is fine with me, I can revert it, or apply a fix, which ever you
> > want, just let me know.
> 
> Well, a proper fix would make this whole episode worthwhile. But if I
> can't come up with anything that actually builds in a day or two it'll
> have to be a revert. If that exceeds your patience you're free to hand
> me a shorter deadline.

How about I revert it now, that way you can provide a proper fix
whenever you get the chance.

thanks,

greg k-h
