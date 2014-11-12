Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753427AbaKLSxf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 13:53:35 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:45302 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753100AbaKLSxe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 13:53:34 -0500
Date: Wed, 12 Nov 2014 13:53:32 -0500 (EST)
Message-Id: <20141112.135332.1998100994393436738.davem@davemloft.net>
To: f.fainelli@gmail.com
Cc: johan@kernel.org, linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 0/3] net: phy: add module_phy_driver macro
From: David Miller <davem@davemloft.net>
In-Reply-To: <54626015.3030907@gmail.com>
References: <1415731559-10015-1-git-send-email-johan@kernel.org>
	<54626015.3030907@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 12 Nov 2014 10:53:34 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>
Date: Tue, 11 Nov 2014 11:14:29 -0800

> On 11/11/2014 10:45 AM, Johan Hovold wrote:
>> Add module_phy_driver macro that can be used by PHY drivers that only
>> calls phy_driver_register or phy_drivers_register (and the corresponding
>> unregister functions) in their module init (and exit).
>> 
>> This allows us to eliminate a lot of boilerplate code.
>> 
>> Split in three patches (actual macro and two driver change classes) in
>> order to facilitate review.
> 
> Looks good to me:
> 
> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>

Series applied, thanks.
