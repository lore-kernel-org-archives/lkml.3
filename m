Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753071AbaHDPAO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 11:00:14 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:35177 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751322AbaHDPAM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 11:00:12 -0400
Date: Mon, 4 Aug 2014 10:53:43 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: "David S. Miller" <davem@davemloft.net>,
        "linux-wireless@vger.kernel.org Wireless" 
	<linux-wireless@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless-next 2014-08-01
Message-ID: <20140804145342.GB16658@tuxdriver.com>
References: <20140801165738.GA26953@tuxdriver.com>
 <20140802.193939.2179004210212543536.davem@davemloft.net>
 <C2EB98EF-6873-4F44-B914-A9F89146914A@holtmann.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <C2EB98EF-6873-4F44-B914-A9F89146914A@holtmann.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 03, 2014 at 10:37:16AM -0700, Marcel Holtmann wrote:
> Hi Dave,
> 
> >> Please pull this last(?) batch of wireless change intended for the
> >> 3.17 stream...
> > 
> > When I pull this I get tons of conflicts for:
> > 
> > CONFLICT (content): Merge conflict in net/6lowpan/iphc.c
> > 
> > I don't feel comfortable fixing these up, where are they coming
> > from?
> 
> I was short on time yesterday, but now I checked up on this in detail. The merge conflicts are actually simple to resolve. You can just rely on John's tree to have the more recent net/6lowpan/ tree. I should have insisted on merging net/6lowpan/ through bluetooth-next and wireless-next way earlier to avoid conflicts.
> 
> In the future we will avoid this by ensuring that all goes via bluetooth-next first. Sorry for this confusion. John mentioned these merge conflicts in his footnote.
> 
> John, do you just want to resolve the merge conflicts and send Dave a new pull request?

I'm happy to do that, if Dave wants.  But as you say, once the initial
shock of all those conflicts passes the resolution really is fairly
simple. :-)

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
