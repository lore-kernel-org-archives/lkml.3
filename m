Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933451AbaHYUAO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 16:00:14 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:55861 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933017AbaHYUAM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 16:00:12 -0400
Date: Mon, 25 Aug 2014 15:59:06 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: pull request: bluetooth-next 2014-08-14
Message-ID: <20140825195906.GF1966@tuxdriver.com>
References: <20140814145000.GA14226@t440s.P-661HNU-F1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140814145000.GA14226@t440s.P-661HNU-F1>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 14, 2014 at 05:50:00PM +0300, Johan Hedberg wrote:
> Hi John,
> 
> Here's our first bluetooth-next pull request for the 3.18 kernel. Our
> tree is based on net-next so you'd need to pull from there first before
> pulling from our tree.
> 
> The changes consists of:
> 
> 	- Coding style fixes to HCI drivers
> 	- Corrupted ack value fix for the H5 HCI driver
> 	- A couple of Enhanced L2CAP fixes
> 	- Conversion of SMP code to use common L2CAP channel API
> 	- Page scan optimizations when using the kernel-side whitelist
> 	- Various mac802154 and and ieee802154 6lowpan cleanups
> 	- One new Atheros USB ID
> 
> Please let me know if there are any issues pulling. Thanks.
> 
> Johan
> 
> ---
> The following changes since commit f0094b28f3038936c1985be64dbe83f0e950b671:
> 
>   Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net (2014-08-13 18:27:40 -0600)
> 
> are available in the git repository at:
> 
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth-next.git for-upstream
> 
> for you to fetch changes up to 13cac15296afe7e42088ecfcd0f1d4b658248c46:
> 
>   Bluetooth: Fix ERTM L2CAP resend packet (2014-08-14 09:47:02 +0200)

Pulling now...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
