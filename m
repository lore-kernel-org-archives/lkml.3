Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934278AbaDITJz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 15:09:55 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37459 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933354AbaDITJy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 15:09:54 -0400
Date: Wed, 9 Apr 2014 12:12:25 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: Felix Fietkau <nbd@openwrt.org>,
        "backports@vger.kernel.org" <backports@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jiri Slaby <jslaby@suse.cz>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: Re: Bumping required kernels to 3.0 for Linux backports ?
Message-ID: <20140409191225.GA10560@kroah.com>
References: <CAB=NE6VvyBKzEg=ErZzQMktY8eLytQ21JCPrOQbxvZ9m-nqHkw@mail.gmail.com>
 <53451077.2030102@openwrt.org>
 <CAB=NE6UUN4vQd3SpsvO5tcgaYq3YXQeE0KtZGki7p7OnR=J4RA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAB=NE6UUN4vQd3SpsvO5tcgaYq3YXQeE0KtZGki7p7OnR=J4RA@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 09, 2014 at 11:28:55AM -0700, Luis R. Rodriguez wrote:
> On Wed, Apr 9, 2014 at 2:18 AM, Felix Fietkau <nbd@openwrt.org> wrote:
> > The oldest kernel in OpenWrt that we're still supporting with updates of
> > the backports tree is 3.3, so raising the minimum requirement to 3.0 is
> > completely fine with me.
> 
> OK note that 3.3 is not listed on kernel.org as supported. I'm fine in
> carrying the stuff for those for now but ultimately it'd also be nice
> if we didn't even have to test the kernels in between which are not
> listed. This does however raise the question of how often a kernel in
> between a list of supported kernels gets picked up to be supported
> eventually. Greg, Jiri, do you happen to know what the likelyhood of
> that can be?

I don't know of anything ever getting picked up after I have said it
would not be supported anymore.

thanks,

greg k-h
