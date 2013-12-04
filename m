Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754370Ab3LDHJs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 02:09:48 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57817 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753192Ab3LDHJe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 02:09:34 -0500
Date: Tue, 3 Dec 2013 23:10:37 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: Rob Landley <rob@landley.net>, Al Viro <viro@zeniv.linux.org.uk>,
        Kay Sievers <kay.sievers@vrfy.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] devtmpfs: Calling delete_path() only when necessary
Message-ID: <20131204071037.GB32026@kroah.com>
References: <1384589723.7840.1.camel@phoenix>
 <1386125959.1974.309@driftwood>
 <CAFRkauAzR=BqJGrMzN0i-tvi5mcQvyB9Kihk0YvxMpk=SWGvFA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFRkauAzR=BqJGrMzN0i-tvi5mcQvyB9Kihk0YvxMpk=SWGvFA@mail.gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 04, 2013 at 02:44:14PM +0800, Axel Lin wrote:
> 2013/12/4 Rob Landley <rob@landley.net>:
> > On 11/16/2013 02:15:23 AM, Axel Lin wrote:
> >>
> >> The deleted variable is always 1 in current code.
> >> Initialize deleted variable to be 0, so delete_path() will be called only
> >> when
> >> necessary.
> >>
> >> Signed-off-by: Axel Lin <axel.lin@ingics.com>
> >
> >
> > I'm not seeing this in linux-next, or a reply on the web archive. Assuming
> > nobody's objected to this, you might want to forward it to
> > trivial@kernel.org.
> >
> > That said, you could describe what it _does_ a little more?
> 
> I was expecting Greg to pick up this patch.
> 
> I thought the description is pretty clear.
> What the patch does is changing the init value of deleted variable to 0.
> The intention of this change is to avoid unnecessary delete_path() call.
> 
> Hi Greg,
> Would you pick up this patch?
> If a re-send or a v2 is required, please just let me know.

It's in my queue to get to, sorry, it's huge and slowly going down, it's
not lost...

greg k-h
