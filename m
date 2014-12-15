Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751236AbaLOSaP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 13:30:15 -0500
Received: from charlotte.tuxdriver.com ([70.61.120.58]:45881 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751131AbaLOSaM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 13:30:12 -0500
Date: Mon, 15 Dec 2014 13:24:11 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: pull request: bluetooth 2014-12-12
Message-ID: <20141215182409.GF21190@tuxdriver.com>
References: <20141212174435.GA22678@t440s.P-661HNU-F1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141212174435.GA22678@t440s.P-661HNU-F1>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 12, 2014 at 07:44:35PM +0200, Johan Hedberg wrote:
> Hi John,
> 
> These fixes are intended for 3.19, note that the tree to pull from is
> bluetooth-next (unlike the subject implies). I'd have normally done a
> pull request from bluetooth.git, but since these fixes for 3.19 is all
> we have so far I thought it's simpler if you just pull from our -next
> tree. The patches consist of:
> 
>  - Coccinelle warning fix
>  - hci_dev_lock/unlock fixes
>  - Fixes for pending mgmt command handling
>  - Fixes for properly following the force_lesc_support switch
>  - Fix for a Microsoft branded Broadcom adapter
>  - New device id for Atheros AR3012
>  - Fix for BR/EDR Secure Connections enabling
> 
> Please let me know if there are any issues pulling. Thanks.
> 
> Johan
> 
> ---
> The following changes since commit 5a34bd5f5d8119def4feb1d2b4e3906b71059416:
> 
>   Bluetooth: Enable events for P-256 Public Key and DHKey commands (2014-12-05 18:17:49 +0200)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth-next.git for-upstream
> 
> for you to fetch changes up to 9845904fd489288bcf693642c1b31cc463c0b660:
> 
>   Bluetooth: Fix mgmt response status when removing adapter (2014-12-12 13:20:12 +0100)

Pulling now...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
