Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753345AbaBYPPz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 10:15:55 -0500
Received: from s3.sipsolutions.net ([144.76.43.152]:54635 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752635AbaBYPPx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 10:15:53 -0500
Message-ID: <1393341342.4170.9.camel@jlt4.sipsolutions.net>
Subject: Re: [PATCHv2 1/5] ARM: tegra: remove obsolete gpio entries
From: Johannes Berg <johannes@sipsolutions.net>
To: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Cc: "David S. Miller" <davem@davemloft.net>, Chen-Yu Tsai <wens@csie.org>,
        Rhyland Klein <rklein@nvidia.com>, Marc Dietrich <marvin24@gmx.de>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Alexandre Courbot <gnurou@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-tegra@vger.kernel.org, Thierry Reding <thierry.reding@gmail.com>
Date: Tue, 25 Feb 2014 16:15:42 +0100
In-Reply-To: <1393330950-7283-2-git-send-email-heikki.krogerus@linux.intel.com>
References: <1393330950-7283-1-git-send-email-heikki.krogerus@linux.intel.com>
	 <1393330950-7283-2-git-send-email-heikki.krogerus@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-02-25 at 14:22 +0200, Heikki Krogerus wrote:
> After moving to description based gpio interface in
> rfkill-gpio, the gpio numbers are not used any more.
> 
> Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
> ---
>  arch/arm/mach-tegra/board-paz00.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)

Hm, ok, I'm not sure I should take a tegra patch through the mac80211 ->
wireless -> networking trees. OTOH, I suppose that the second patch
depends on this. I can take it all I suppose, Thierry? Stephen?

johannes

