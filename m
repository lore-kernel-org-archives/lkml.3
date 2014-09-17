Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755782AbaIQPtw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 11:49:52 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:51263 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754870AbaIQPtv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 11:49:51 -0400
Message-ID: <5419AD9B.90207@ti.com>
Date: Wed, 17 Sep 2014 21:19:47 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: <gregkh@linuxfoundation.org>
CC: <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL 0/3] PHY: Fixes for 3.17 -rc cycle
References: <1410530774-6715-1-git-send-email-kishon@ti.com>
In-Reply-To: <1410530774-6715-1-git-send-email-kishon@ti.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

On Friday 12 September 2014 07:36 PM, Kishon Vijay Abraham I wrote:
> Hi Greg,
> 
> here's one more PULL REQUEST for this -rc cycle. It consists of only
> three fixes one in miphy365 PHY driver and the other two in Kconfig.
> 
> Please consider merging this in ths -rc cycle. Let me know if I have to
> change something.

ping on this..

-Kishon
> 
> Cheers
> Kishon
> 
> The following changes since commit fbb1a770039d3900f5130bab949b757f6f7fb373:
> 
>   phy: miphy365x: Select GENERIC_PHY instead of depending on it (2014-08-28 11:17:43 +0530)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/kishon/linux-phy.git tags/for_3.17-rc
> 
> for you to fetch changes up to 7652d35f98b5049be370835182a98ba5689f8361:
> 
>   phy: spear1340-miphy: fix driver dependencies (2014-09-12 11:35:31 +0530)
> 
> ----------------------------------------------------------------
> misc fixes in PHY drivers
> 
> ----------------------------------------------------------------
> Bartlomiej Zolnierkiewicz (2):
>       phy: spear1310-miphy: fix driver dependencies
>       phy: spear1340-miphy: fix driver dependencies
> 
> Lee Jones (1):
>       phy: miphy365x: Fix off-by-one error
> 
>  drivers/phy/Kconfig         |    2 ++
>  drivers/phy/phy-miphy365x.c |    1 +
>  2 files changed, 3 insertions(+)
> 
