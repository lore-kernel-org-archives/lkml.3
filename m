Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751934Ab3LRTaU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 14:30:20 -0500
Received: from charlotte.tuxdriver.com ([70.61.120.58]:45829 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751074Ab3LRTaR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 14:30:17 -0500
Date: Wed, 18 Dec 2013 14:23:30 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Gustavo Padovan <gustavo@padovan.org>, linux-wireless@vger.kernel.org,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: pull request: bluetooth 2013-12-18
Message-ID: <20131218192330.GC3096@tuxdriver.com>
References: <20131218125236.GA1376@joana>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131218125236.GA1376@joana>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 18, 2013 at 10:52:36AM -0200, Gustavo Padovan wrote:
> Hi John,
> 
> Two patches in this pull request. An important fix from Marcel in the
> permission check for HCI User Channels, there was a extra check for
> CAP_NET_RAW, and it was now removed. These channels should only require
> CAP_NET_ADMIN. The other patch is a device id addition.
> 
> Please pull or let me know of any problems! Thanks.
> 
>         Gustavo
> 
> ---
> The following changes since commit eafbdde9c5629bea58df07275c5917eb42afbbe7:
> 
>   rtlwifi: rtl8192cu: Fix more pointer arithmetic errors (2013-11-15 14:29:33 -0500)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth.git for-upstream
> 
> for you to fetch changes up to 1bc5ad168f441f6f8bfd944288a5f7b4963ac1f6:
> 
>   Bluetooth: Fix HCI User Channel permission check in hci_sock_sendmsg (2013-12-17 13:47:27 +0200)

Pulling now...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
