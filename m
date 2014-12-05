Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751794AbaLETPO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 14:15:14 -0500
Received: from charlotte.tuxdriver.com ([70.61.120.58]:57959 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750893AbaLETPM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 14:15:12 -0500
Date: Fri, 5 Dec 2014 14:14:17 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: pull request: bluetooth-next 2014-12-05
Message-ID: <20141205191416.GD28319@tuxdriver.com>
References: <20141205125318.GA24487@t440s.lan>
 <20141205164149.GA1087@t440s.P-661HNU-F1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141205164149.GA1087@t440s.P-661HNU-F1>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 05, 2014 at 06:41:49PM +0200, Johan Hedberg wrote:
> Hi John,
> 
> Marcel had a couple more patches that were supposed to be in the pull
> request, so here's a new one that supersedes the one I made earlier
> today.
> 
> In addition to the previous one this contains two more cleanups to
> mac802154 as well as support for some new HCI features from the
> Bluetooth 4.2 specification.
> 
> From the original request:
> 
> "Here's what should be the last bluetooth-next pull request for 3.19.
> It's rather large but the majority of it is the Low Energy Secure
> Connections feature that's part of the Bluetooth 4.2 specification. The
> specification went public only this week so we couldn't publish the
> corresponding code before that. The code itself can nevertheless be
> considered fairly mature as it's been in development for over 6 months
> and gone through several interoperability test events.
> 
> Besides LE SC the pull request contains an important fix for command
> complete events for mgmt sockets which also fixes some leaks of hci_conn
> objects when powering off or unplugging Bluetooth adapters.
> 
> A smaller feature that's part of the pull request is service discovery
> support. This is like normal device discovery except that devices not
> matching specific UUIDs or strong enough RSSI are filtered out.
> 
> Other changes that the pull request contains are firmware dump support
> to the btmrvl driver, firmware download support for Broadcom BCM20702A0
> variants, as well as some coding style cleanups in 6lowpan &
> ieee802154/mac802154 code."
> 
> Please let me know if there are any issues pulling. Thanks.
> 
> Johan
> 
> ---
> The following changes since commit f6af675ef5489c69fc3d4faf8c6f477df3cbf8b9:
> 
>   Bluetooth: Automatically flushable packets aren't allowed on LE links (2014-11-27 12:12:27 +0200)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth-next.git for-upstream
> 
> for you to fetch changes up to 5a34bd5f5d8119def4feb1d2b4e3906b71059416:
> 
>   Bluetooth: Enable events for P-256 Public Key and DHKey commands (2014-12-05 18:17:49 +0200)

Pulling now...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
