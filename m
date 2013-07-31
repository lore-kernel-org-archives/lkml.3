Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757208Ab3GaTPQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 15:15:16 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:56920 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753289Ab3GaTPO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 15:15:14 -0400
Date: Wed, 31 Jul 2013 15:08:02 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Gustavo Padovan <gustavo@padovan.org>, linux-wireless@vger.kernel.org,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: pull request: bluetooth 2013-07-30
Message-ID: <20130731190801.GE2311@tuxdriver.com>
References: <20130730123848.GE5975@joana>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130730123848.GE5975@joana>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 30, 2013 at 01:38:48PM +0100, Gustavo Padovan wrote:
> Hi John,
> 
> A few fixes and devices ID additions for 3.11: 
> 
>  * There are 4 new ath3k device ids 
>  * Fixed stack memory usage in ath3k.
>  * Fixed the init process of BlueFRITZ! devices, they were failing to init
>    due to an unsupported command we sent. 
>  * Fixed wrong use of PTR_ERR in btusb code that was preventing intel devices
>    to work properly.
>  * Fixed race condition between hci_register_dev() and hci_dev_open() that
>    could cause a NULL pointer dereference.
>  * Fixed race condition that could call hci_req_cmd_complete() and make some
>    devices to fail as showed in the log added to the commit message.
> 
> Please pull or let me know of any issues. Thanks.
> 
> 	Gustavo
> 
> --
> The following changes since commit 075163bbb0f51174359947e1bce84f5edb23f21e:
> 
>   ath9k_htc: Handle IDLE state transition properly (2013-06-24 13:52:52 -0400)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth master
> 
> for you to fetch changes up to 53e21fbc288218a423959f878c86471a0e323a9a:
> 
>   Bluetooth: Fix calling request callback more than once (2013-07-29 12:28:04 +0100)

Pulling now...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
