Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755030Ab3GJSHx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 14:07:53 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:43539 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754886Ab3GJSHv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 14:07:51 -0400
Date: Wed, 10 Jul 2013 11:07:48 -0700 (PDT)
Message-Id: <20130710.110748.586660361286840099.davem@davemloft.net>
To: markus@trippelsdorf.de
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alexey.Brodkin@synopsys.com
Subject: Re: [GIT] Networking
From: David Miller <davem@davemloft.net>
In-Reply-To: <20130710122523.GA357@x4>
References: <20130709.145325.1363244885668360965.davem@davemloft.net>
	<20130710122523.GA357@x4>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Markus Trippelsdorf <markus@trippelsdorf.de>
Date: Wed, 10 Jul 2013 14:25:23 +0200

> On 2013.07.09 at 14:53 -0700, David Miller wrote:
>> 
>> Alexey Brodkin (2):
>>       ethernet/arc/arc_emac - Add new driver
>>       arc_emac: fix compile-time errors & warnings on PPC64
> 
> This driver defaults to y for no reason:
> 
> +config NET_VENDOR_ARC
> +       bool "ARC devices"
> +       default y

That doesn't enable the driver, it enables Kconfig options for drivers
for that vendor.  If this is off, the user won't even be offered the
Kconfig option for the driver.

This is consistent with how we handle the other vendor guards for
networking driver Kconfigs.
