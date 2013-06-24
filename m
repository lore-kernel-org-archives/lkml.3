Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753129Ab3FXTAQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 15:00:16 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:37741 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753010Ab3FXTAK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 15:00:10 -0400
Date: Mon, 24 Jun 2013 14:46:13 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Gustavo Padovan <gustavo@padovan.org>, linux-wireless@vger.kernel.org,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: pull request: bluetooth-next 2013-06-23
Message-ID: <20130624184613.GE1997@tuxdriver.com>
References: <20130623022356.GB2327@joana>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130623022356.GB2327@joana>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 23, 2013 at 03:23:56AM +0100, Gustavo Padovan wrote:
> Hi John,
> 
> Here goes a set of patches to 3.11. The biggest work here is from Andre Guedes
> on the move of the Discovery to use the new request framework. Other than that
> Johan provided a bunch of fixes to the L2CAP code. The rest are just small
> fixes and clean ups. 
> 
> Please pull or let me know of any problem! Thanks.
> 
> 	Gustavo
> 
> ---
> The following changes since commit b887664d882ee4f6a67e0bf05e5f141d32fcc067:
> 
>   mwifiex: channel switch handling for station (2013-06-19 15:28:43 -0400)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth-next for-upstream
> 
> for you to fetch changes up to b8f4e068004859eefac7b1ced59ddb67ca6d2d80:
> 
>   Bluetooth: Improve comments on the HCI_Delete_Store_Link_Key issue (2013-06-23 03:05:47 +0100)

Pulling now...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
