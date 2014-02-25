Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753453AbaBYR7V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 12:59:21 -0500
Received: from senator.holtmann.net ([87.106.208.187]:56268 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752635AbaBYR7S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 12:59:18 -0500
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 7.1 \(1827\))
Subject: Re: [PATCHv2 0/5] net: rfkill: gpio: cleanup and a few new acpi ids
From: Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <1393341068.4170.7.camel@jlt4.sipsolutions.net>
Date: Tue, 25 Feb 2014 09:59:07 -0800
Cc: Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>, Chen-Yu Tsai <wens@csie.org>,
        Rhyland Klein <rklein@nvidia.com>, Marc Dietrich <marvin24@gmx.de>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Alexandre Courbot <gnurou@gmail.com>,
        "linux-wireless@vger.kernel.org Wireless" 
	<linux-wireless@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <D8A6682F-CC21-4428-AFA3-C50FBA8ED1F7@holtmann.org>
References: <1393330950-7283-1-git-send-email-heikki.krogerus@linux.intel.com> <1393341068.4170.7.camel@jlt4.sipsolutions.net>
To: Johannes Berg <johannes@sipsolutions.net>
X-Mailer: Apple Mail (2.1827)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Johannes,

>> I was waiting for the DT support from Chen-Yu before sending these,
>> but decided it makes no difference when I send them. I'm dropping the
>> con ID in the second patch because Dan noticed the warning, but of
>> course it will mean the "gpios" property can be used with DT.
>> 
>> The two last patches just add ACPI IDs for some new Baytrail based
>> boards.
> 
> Do these patches have any dependencies, or should I just add them to the
> mac80211-next tree (since I don't keep a separate rfkill tree)?
> 
> Or does anyone else want to take them? In that case, it's all fine with
> me, I'm really just nominally the rfkill maintainer and have no idea
> about these patches... :)

someone has to take them. So I say go for it.

Regards

Marcel

