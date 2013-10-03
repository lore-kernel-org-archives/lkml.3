Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755420Ab3JCUaR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 16:30:17 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:39294 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755360Ab3JCUaP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 16:30:15 -0400
Date: Thu, 3 Oct 2013 16:19:35 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Gustavo Padovan <gustavo@padovan.org>, linux-wireless@vger.kernel.org,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: pull request: bluetooth-next 2013-10-03
Message-ID: <20131003201935.GF3142@tuxdriver.com>
References: <20131003174524.GA22728@joana>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131003174524.GA22728@joana>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 03, 2013 at 02:45:24PM -0300, Gustavo Padovan wrote:
> Hi John,
> 
> A series of patches for 3.12. The big work here is from Marcel and Johan. They
> did a lot of work in the L2CAP, HCI and MGMT layers. The most important ones
> are the addition of a new MGMT command to enable/disable LE advertisement and
> the introduction of the HCI user channel to allow applications to get directly
> and exclusive access to Bluetooth devices.
> 
> Please pull, or let me know of any issues. Thanks!
> 
> 	Gustavo
> 
> --
> The following changes since commit f4e1a4d3ecbb9e42bdf8e7869ee8a4ebfa27fb20:
> 
>   rt2800: change initialization sequence to fix system freeze (2013-09-09 14:44:34 -0400)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth-next for-upstream
> 
> for you to fetch changes up to 4f3e219d95a3c31b916dcd5e2631c4e440736f79:
> 
>   Bluetooth: Only one command per L2CAP LE signalling is supported (2013-10-03 16:09:59 +0300)

Pulling now...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
