Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932282AbaKRUPS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 15:15:18 -0500
Received: from charlotte.tuxdriver.com ([70.61.120.58]:53768 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932124AbaKRUPP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 15:15:15 -0500
Date: Tue, 18 Nov 2014 15:14:36 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: pull request: bluetooth-next 2014-11-18
Message-ID: <20141118201435.GE13458@tuxdriver.com>
References: <20141118091952.GA14015@t440s.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141118091952.GA14015@t440s.lan>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 18, 2014 at 11:19:52AM +0200, Johan Hedberg wrote:
> Hi John,
> 
> Here's another bluetooth-next pull request for 3.19. We've got:
> 
>  - Various fixes, cleanups and improvements to ieee802154/mac802154
>  - Support for a Broadcom BCM20702A1 variant
>  - Lots of lockdep fixes
>  - Fixed handling of LE CoC errors that should trigger SMP
> 
> Please let me know if there are any issues pulling. Thanks.
> 
> Johan
> 
> ---
> The following changes since commit 56b2c3eea398c772dd895dc62c18cbdd1ba127b1:
> 
>   6lowpan: move skb_free from error paths in decompression (2014-11-06 22:09:48 +0100)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth-next.git for-upstream
> 
> for you to fetch changes up to a86c02ea38c53b695209b1181f9e2e18d73eb4e8:
> 
>   Bluetooth: Add support for Broadcom BCM20702A1 variant (2014-11-18 08:32:14 +0100)

Pulling now...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
