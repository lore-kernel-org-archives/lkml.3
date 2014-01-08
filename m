Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757345AbaAHTAS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 14:00:18 -0500
Received: from charlotte.tuxdriver.com ([70.61.120.58]:55305 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752523AbaAHTAQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 14:00:16 -0500
Date: Wed, 8 Jan 2014 13:45:43 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Gustavo Padovan <gustavo@padovan.org>, linux-wireless@vger.kernel.org,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: pull request: bluetooth-next 2014-01-07
Message-ID: <20140108184543.GE11076@tuxdriver.com>
References: <20140107152251.GA24183@joana>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140107152251.GA24183@joana>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 07, 2014 at 01:22:51PM -0200, Gustavo Padovan wrote:
> Hi John,
> 
> More patches to 3.14. The bulk of changes here is the 6LoWPAN support for
> Bluetooth LE Devices. The commits that touches net/ieee802154/ are already
> acked by David Miller. Other than that we have some RFCOMM fixes and
> improvements plus fixes and clean ups all over the tree.
> 
> Please pull, or let me know of any concerns you have.
> 
> 	Gustavo
> 
> ---
> The following changes since commit 71fb419724fadab4efdf98210aa3fe053bd81d29:
> 
>   Bluetooth: Fix handling of L2CAP Command Reject over LE (2013-12-10 01:15:44 -0800)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth-next.git for-upstream
> 
> for you to fetch changes up to e825eb1d7e06f616003c17e2e8e421c2e5e44142:
> 
>   Bluetooth: Fix 6loWPAN peer lookup (2014-01-07 11:32:15 -0200)

Pulling now...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
