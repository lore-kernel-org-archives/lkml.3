Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752667AbaKKVpL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 16:45:11 -0500
Received: from charlotte.tuxdriver.com ([70.61.120.58]:50548 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751736AbaKKVpJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 16:45:09 -0500
Date: Tue, 11 Nov 2014 16:35:02 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: pull request: bluetooth-next 2014-11-07
Message-ID: <20141111213501.GG6780@tuxdriver.com>
References: <20141107092754.GA6995@t440s.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141107092754.GA6995@t440s.lan>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 07, 2014 at 11:27:54AM +0200, Johan Hedberg wrote:
> Hi John
> 
> Here's another set of patches for 3.19. Most of it is again fixes and
> cleanups to ieee802154 related code from Alexander Aring. We've also got
> better handling of hardware error events along with a proper API for HCI
> drivers to notify the HCI core of such situations. There's also a minor
> fix for mgmt events as well as a sparse warning fix. The code for
> sending HCI commands synchronously also gets a fix where we might loose
> the completion event in the case of very fast HW (particularly easily
> reproducible with an emulated HCI device).
> 
> Please let me know if there are any issues pulling. Thanks.
> 
> Johan
> 
> ---
> The following changes since commit 6bc6c49f1e2f3ab1bec05d1c08aad219ab4eb5d0:
> 
>   mwifiex: add cfg80211 dump_survey handler (2014-10-31 16:07:49 -0400)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth-next.git for-upstream
> 
> for you to fetch changes up to 56b2c3eea398c772dd895dc62c18cbdd1ba127b1:
> 
>   6lowpan: move skb_free from error paths in decompression (2014-11-06 22:09:48 +0100)

Pulling now...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
