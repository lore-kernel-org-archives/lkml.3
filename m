Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756594AbaF3Rxz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 13:53:55 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48255 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754774AbaF3Rxy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 13:53:54 -0400
Date: Mon, 30 Jun 2014 19:53:51 +0200
From: "Luis R. Rodriguez" <mcgrof@suse.com>
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Cc: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>, linux-firmware@kernel.org,
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] README: clarify redistribution requirements covering
	patents
Message-ID: <20140630175351.GL27687@wotan.suse.de>
References: <1403897967-5894-1-git-send-email-mcgrof@do-not-panic.com> <20140628163108.0b8b81ce@alan.etchedpixels.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140628163108.0b8b81ce@alan.etchedpixels.co.uk>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 28, 2014 at 04:31:08PM +0100, One Thousand Gnomes wrote:
> > +the firmware license provided includes an implicit or explicit
> > +patent grant to end users to ensure full functionality of device
> > +operation with the firmware. If the licence is long and involved, it's
> >  permitted to include it in a separate file and refer to it from the
> >  WHENCE file.
> >  And if it were possible, a changelog of the firmware itself.
> 
> "end users of the device" or just "end users"
> 
> I'm assuming the worry for most vendors is licensing it to be used on
> some third party product ?

The proposed language includes both whereas the "end users of the device"
would exclude some subset use including the implicit license use case.
Thoughts?

  Luis
