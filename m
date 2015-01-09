Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757786AbbAIOCq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 09:02:46 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:51906 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756062AbbAIOCp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 09:02:45 -0500
Message-ID: <54AFDF82.6040504@ti.com>
Date: Fri, 9 Jan 2015 19:32:42 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: <gregkh@linuxfoundation.org>
CC: <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL 0/3] phy: fixes for 3.19 -rc cycle
References: <1420015549-20697-1-git-send-email-kishon@ti.com>
In-Reply-To: <1420015549-20697-1-git-send-email-kishon@ti.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

On Wednesday 31 December 2014 02:15 PM, Kishon Vijay Abraham I wrote:
> Hi Greg,
> 
> Please find the pull request for 3.19 -rc cycle. This contains misc fixes
> in PHY drivers.
> 
> Let me know if I have to change something.

Can you pick this series for this -rc cyle?

Thanks
Kishon
> 
> Thanks
> Kishon
> 
> The following changes since commit aa39477b5692611b91ac9455ae588738852b3f60:
> 
>   Merge tag 'dm-3.19-fixes' of git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm (2014-12-22 14:47:17 -0800)
> 
> are available in the git repository at:
> 
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/kishon/linux-phy.git tags/for-3.19-rc
> 
> for you to fetch changes up to 0bc09f9cdc589e0b54724096138996a00b19babb:
> 
>   phy: phy-ti-pipe3: fix inconsistent enumeration of PCIe gen2 cards (2014-12-23 15:44:32 +0530)
> 
> ----------------------------------------------------------------
> misc fixes in PHY drivers
> 
> ----------------------------------------------------------------
> Dan Carpenter (1):
>       phy: miphy28lp: unlock on error in miphy28lp_init()
> 
> Hans de Goede (1):
>       phy-sun4i-usb: Change disconnect threshold value for sun6i
> 
> Vignesh R (1):
>       phy: phy-ti-pipe3: fix inconsistent enumeration of PCIe gen2 cards
> 
>  drivers/phy/phy-miphy28lp.c          |    3 ++-
>  drivers/phy/phy-omap-control.c       |    7 +++----
>  drivers/phy/phy-sun4i-usb.c          |    3 ++-
>  drivers/phy/phy-ti-pipe3.c           |   10 ++++++----
>  include/linux/phy/omap_control_phy.h |    6 +++---
>  5 files changed, 16 insertions(+), 13 deletions(-)
> 
