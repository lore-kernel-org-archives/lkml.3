Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933057AbaDVPHY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 11:07:24 -0400
Received: from s3.sipsolutions.net ([144.76.43.152]:42644 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933039AbaDVPHO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 11:07:14 -0400
Message-ID: <1398179202.4211.15.camel@jlt4.sipsolutions.net>
Subject: Re: [PATCH 0/7] net: rfkill: gpio: Add device tree support
From: Johannes Berg <johannes@sipsolutions.net>
To: Chen-Yu Tsai <wens@csie.org>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        "John W. Linville" <linville@tuxdriver.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Alexandre Courbot <gnurou@gmail.com>,
        Stephen Warren <swarren@wwwdotorg.org>, linux-gpio@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sunxi@googlegroups.com
Date: Tue, 22 Apr 2014 17:06:42 +0200
In-Reply-To: <1397544101-18135-1-git-send-email-wens@csie.org>
References: <1397544101-18135-1-git-send-email-wens@csie.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-04-15 at 14:41 +0800, Chen-Yu Tsai wrote:

> The first 2 patches should go through the gpio tree. The 4 rfkill-gpio
> patches should go through the same tree that Heikki's patches are
> in. Maxime, can you take the last one?

Are there no dependencies? Maybe it'd be easier if you sent it as
separate patch series then?

I can take those four patches into my topic branch on top of Heikki's
patches, but in any case, there seem to be a bunch of
comments/discussions so for now I'm not going to do anything with them.

johannes

