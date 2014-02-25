Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753318AbaBYPL1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 10:11:27 -0500
Received: from s3.sipsolutions.net ([144.76.43.152]:54585 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753246AbaBYPLZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 10:11:25 -0500
Message-ID: <1393341068.4170.7.camel@jlt4.sipsolutions.net>
Subject: Re: [PATCHv2 0/5] net: rfkill: gpio: cleanup and a few new acpi ids
From: Johannes Berg <johannes@sipsolutions.net>
To: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Cc: "David S. Miller" <davem@davemloft.net>, Chen-Yu Tsai <wens@csie.org>,
        Rhyland Klein <rklein@nvidia.com>, Marc Dietrich <marvin24@gmx.de>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Alexandre Courbot <gnurou@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-tegra@vger.kernel.org
Date: Tue, 25 Feb 2014 16:11:08 +0100
In-Reply-To: <1393330950-7283-1-git-send-email-heikki.krogerus@linux.intel.com>
References: <1393330950-7283-1-git-send-email-heikki.krogerus@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-02-25 at 14:22 +0200, Heikki Krogerus wrote:

> I was waiting for the DT support from Chen-Yu before sending these,
> but decided it makes no difference when I send them. I'm dropping the
> con ID in the second patch because Dan noticed the warning, but of
> course it will mean the "gpios" property can be used with DT.
> 
> The two last patches just add ACPI IDs for some new Baytrail based
> boards.

Do these patches have any dependencies, or should I just add them to the
mac80211-next tree (since I don't keep a separate rfkill tree)?

Or does anyone else want to take them? In that case, it's all fine with
me, I'm really just nominally the rfkill maintainer and have no idea
about these patches... :)

johannes

