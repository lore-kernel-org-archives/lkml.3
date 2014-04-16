Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752555AbaDPDRK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 23:17:10 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:42482 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750993AbaDPDRI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 23:17:08 -0400
Date: Tue, 15 Apr 2014 23:17:06 -0400 (EDT)
Message-Id: <20140415.231706.812725635915796409.davem@davemloft.net>
To: chealy@imsco-us.com
Cc: linux@roeck-us.net, f.fainelli@gmail.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, cphealy@gmail.com
Subject: Re: [PATCH 1/3] net: mdio-gpio: Use devm_ functions where possible
From: David Miller <davem@davemloft.net>
In-Reply-To: <724F6C6CDC8C86478473775085778C4E09E85E3A@ImsEx1.ims.dom>
References: <1397614602-29694-1-git-send-email-linux@roeck-us.net>
	<1397614602-29694-2-git-send-email-linux@roeck-us.net>
	<724F6C6CDC8C86478473775085778C4E09E85E3A@ImsEx1.ims.dom>
X-Mailer: Mew version 6.5 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 15 Apr 2014 20:17:08 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chris Healy <chealy@imsco-us.com>
Date: Wed, 16 Apr 2014 02:50:08 +0000

> This simplifies error path and deinit/removal functions.
> 
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> Tested-by: Chris Healy <cphealy@gmail.com>

This isn't the way to add a Tested-by: tag of your own if that
is what you're trying to do.

The proper way is to reply to the original patch, quote only the
commit message, and then add your Tested-by: after the quoted
material.
