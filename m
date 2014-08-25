Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933473AbaHYTpO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 15:45:14 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:55691 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751127AbaHYTpM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 15:45:12 -0400
Date: Mon, 25 Aug 2014 15:35:46 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: alex.aring@gmail.com, linux-wireless@vger.kernel.org,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: pull request: bluetooth 2014-08-20
Message-ID: <20140825193545.GE1966@tuxdriver.com>
References: <20140820191438.GA16364@t440s.P-661HNU-F1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140820191438.GA16364@t440s.P-661HNU-F1>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 20, 2014 at 10:14:38PM +0300, Johan Hedberg wrote:
> Hi John,
> 
> Here's a set of patches for the 3.17-rc series.
> 
> It contains a connection reference counting fix for LE where a
> connection might stay up even though it should get disconnected.
> 
> The other 802.15.4 6LoWPAN related patches were sent to the bluetooth
> tree by Alexander Aring and described as follows by him:
> 
> "
> these patches contains patches for the bluetooth branch.
> 
> This series includes memory leak fixes and an errno value fix.
> Also there are two patches for sending and receiving 1280 6LoWPAN
> packets, which makes the IEEE 802.15.4 6LoWPAN stack more RFC
> compliant.
> "
> 
> Please let me know if there are any issues pulling. Thanks.
> 
> Johan
> 
> ---
> The following changes since commit 77b2f2865956b7573f9b040db7a9f808b434acd1:
> 
>   iwlwifi: mvm: disable scheduled scan to prevent firmware crash (2014-08-14 19:47:41 +0300)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth.git for-upstream
> 
> for you to fetch changes up to f161dd4122ffa73e4e12000309dca65bec80d416:
> 
>   Bluetooth: Fix hci_conn reference counting for auto-connections (2014-08-20 21:57:39 +0300)

Pulling now...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
