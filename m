Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758295Ab3FDF6t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 01:58:49 -0400
Received: from mo-p05-ob.rzone.de ([81.169.146.180]:51107 "EHLO
	mo-p05-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753279Ab3FDF6r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 01:58:47 -0400
X-Greylist: delayed 352 seconds by postgrey-1.27 at vger.kernel.org; Tue, 04 Jun 2013 01:58:46 EDT
X-RZG-AUTH: :IW0NeWC7b/q2i6W/qstXb1SBUuFnrGoheedClaTaNdBkW0QEactrFOkxARSLB12SU2w=
X-RZG-CLASS-ID: mo05
Message-ID: <51AD80A5.20308@denx.de>
Date: Tue, 04 Jun 2013 07:52:37 +0200
From: Stefan Roese <sr@denx.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Richard Genoud <richard.genoud@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] net: sun4i-emac: remove erroneous assignment
References: <3298610.K0DeJZEM4E@wuerfel>
In-Reply-To: <3298610.K0DeJZEM4E@wuerfel>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/03/2013 11:36 PM, Arnd Bergmann wrote:
> The newly added sun4i-emac driver causes a build error when
> CONFIG_NET_POLL_CONTROLLER is set, because it attempts to
> assign a pointer to netdev->poll_controller, which has
> been replaced with ops->ndo_poll_controller in 2.6.31!
> 
> The correct assignment is present as well, so we just need
> to remove the wrong one.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Stefan Roese <sr@denx.de>
> Cc: Maxime Ripard <maxime.ripard@free-electrons.com>
> Cc: Richard Genoud <richard.genoud@gmail.com>

Thanks for fixing this:

Acked-by: Stefan Roese <sr@denx.de>

Thanks,
Stefan

