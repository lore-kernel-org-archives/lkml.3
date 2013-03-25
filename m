Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933176Ab3CYUpv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 16:45:51 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:42164 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758894Ab3CYUpt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 16:45:49 -0400
Date: Mon, 25 Mar 2013 16:40:25 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Gustavo Padovan <gustavo@padovan.org>, linux-wireless@vger.kernel.org,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: pull request: bluetooth-next 2013-03-21
Message-ID: <20130325204025.GF17454@tuxdriver.com>
References: <20130321222408.GA8890@joana>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130321222408.GA8890@joana>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 21, 2013 at 07:24:08PM -0300, Gustavo Padovan wrote:
> Hi John,
> 
> This is our first batch of patches for 3.10. The biggest changes of this pull
> request are from Johan Hedberg, he implemented a HCI request framework to make
> life easier when we have to send many HCI commands and a block and wait for
> all of the to finish, we were able to fix a few issues in stack with the
> introduction of this framework.
> 
> Other than that Dean Jenkins did a good work cleaning the RFCOMM code, the
> refcnt infrastructure was removed and now we use NULL pointer checks to know
> when a object was freed or not. That code was buggy and now it looks a way
> better.
> 
> The rest of changes are clean ups, fixes and small improvements all over the
> Bluetooth subsystem. 
> 
> Please pull, or let me know of any issues! Thanks.
> 
> 	Gustavo
> 
> ---
> The following changes since commit 7da060c1c01b103d181dba39bce9bd141a945f99:
> 
>   mwifiex: add WOWLAN support (2013-03-06 16:29:17 -0500)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth-next for-upstream
> 
> for you to fetch changes up to 0227c7b56959cd8f5edd20b6a47db86fa553e91a:
> 
>   Bluetooth: fix error return code in rfcomm_add_listener() (2013-03-20 14:17:52 -0300)

Pulling now...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
