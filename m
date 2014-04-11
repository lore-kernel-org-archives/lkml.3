Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755351AbaDKHdY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 03:33:24 -0400
Received: from s3.sipsolutions.net ([144.76.43.152]:50726 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754925AbaDKHdX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 03:33:23 -0400
Message-ID: <1397201577.4420.1.camel@jlt4.sipsolutions.net>
Subject: Re: [PATCHv3 0/5] net: rfkill: gpio: cleanup and a few new acpi ids
From: Johannes Berg <johannes@sipsolutions.net>
To: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Cc: Chen-Yu Tsai <wens@csie.org>, Rhyland Klein <rklein@nvidia.com>,
        Marc Dietrich <marvin24@gmx.de>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Alexandre Courbot <gnurou@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-tegra@vger.kernel.org
Date: Fri, 11 Apr 2014 09:32:57 +0200
In-Reply-To: <1396360976-28657-1-git-send-email-heikki.krogerus@linux.intel.com>
References: <1396360976-28657-1-git-send-email-heikki.krogerus@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-04-01 at 17:02 +0300, Heikki Krogerus wrote:
> Hi,
> 
> I hope this one is OK with everyone.

Looks good to me, all applied.

It's in jberg/mac80211-next.git rfkill-gpio-cleanups branch, in case
anybody needs this separately. John isn't taking pull requests for -next
until after -rc1, at which point I'll send it to him.

johannes

