Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755595Ab3KEVAa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 16:00:30 -0500
Received: from charlotte.tuxdriver.com ([70.61.120.58]:34530 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755408Ab3KEVA2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 16:00:28 -0500
Date: Tue, 5 Nov 2013 15:50:55 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Gustavo Padovan <gustavo@padovan.org>, linux-wireless@vger.kernel.org,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: pull request: bluetooth-next 2013-10-21
Message-ID: <20131105205055.GE8264@tuxdriver.com>
References: <20131021223736.GA2043@joana>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131021223736.GA2043@joana>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 21, 2013 at 08:37:36PM -0200, Gustavo Padovan wrote:
> Hi John,
> 
> One more big pull request for 3.13. These are the patches we queued during
> last week. Here you will find a lot of improvements to the HCI and L2CAP and
> MGMT layers with the main ones being a better debugfs support and end of work
> of splitting L2CAP into Core and Socket parts.
> 
> Please pull!
> 
> 	Gustavo
> 
> ---
> The following changes since commit 4b836f393bd8ed111857a6ee1865e44627266ec6:
> 
>   Bluetooth: Read current IAC LAP on controller setup (2013-10-14 19:31:18 -0300)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth-next for-upstream
> 
> for you to fetch changes up to d78a32a8fcf775111ccc9ba611a08ca5c29784b6:
> 
>   Bluetooth: Remove sk member from struct l2cap_chan (2013-10-21 13:50:56 -0700)

Pulling now...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
