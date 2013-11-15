Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751771Ab3KOTaY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 14:30:24 -0500
Received: from charlotte.tuxdriver.com ([70.61.120.58]:35471 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751268Ab3KOTaT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 14:30:19 -0500
Date: Fri, 15 Nov 2013 14:19:13 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Gustavo Padovan <gustavo@padovan.org>, linux-wireless@vger.kernel.org,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: pull request: bluetooth 2013-11-11
Message-ID: <20131115191912.GE7079@tuxdriver.com>
References: <20131111182738.GB5648@joana>
 <20131111190548.GA8107@tuxdriver.com>
 <20131115151554.GB1627@joana>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131115151554.GB1627@joana>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 15, 2013 at 01:15:54PM -0200, Gustavo Padovan wrote:
> Hi John,
> 
> 2013-11-11 John W. Linville <linville@tuxdriver.com>:
> 
> > On Mon, Nov 11, 2013 at 04:27:38PM -0200, Gustavo Padovan wrote:
> > > Hi John,
> > > 
> > > A few fixes for 3.13. There is 3 fixes to the RFCOMM protocol. One crash fix to
> > > L2CAP. A simple fix to a bad behaviour in the SMP protocol, and last, an
> > > revert, that I sent in the last pull request but doesn't seem to be in your
> > > tree.
> > 
> > Are you looking in the wireless-next tree?  It seems to be there, no?
> 
> Yes, it is there. I'm resending this pull request without it:
> 
> Please pull or let me know of any problems! Thanks
> 
> 	Gustavo
> 
> ---
> 
> The following changes since commit 8ce9beac4661f576ea0d518b9f086bb52a171a37:
> 
>   drivers: net: wireless: b43: Fix possible NULL ptr dereference (2013-10-18 13:41:11 -0400)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth for-upstream
> 
> for you to fetch changes up to 86ca9eac31d0d8c4fe61b5726e6d63197bc435a6:
> 
>   Bluetooth: Fix rejecting SMP security request in slave role (2013-11-13 11:36:54 -0200)

Pulling now...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
