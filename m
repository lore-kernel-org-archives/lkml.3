Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752860AbaBMXm0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 18:42:26 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:51503 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752056AbaBMXmY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 18:42:24 -0500
Date: Thu, 13 Feb 2014 18:42:21 -0500 (EST)
Message-Id: <20140213.184221.1712626655601756449.davem@davemloft.net>
To: sergei.shtylyov@cogentembedded.com
Cc: liujunliang_ljl@163.com, thierry.reding@gmail.com, horms@verge.net.au,
        joe@perches.com, romieu@fr.zoreil.com, gregkh@linuxfoundation.org,
        netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, sunhecheng@vip.126.com
Subject: Re: [PATCH] Fix Default to 'y' for SR9800 Device Driver, setting
 to 'n'
From: David Miller <davem@davemloft.net>
In-Reply-To: <52FD6579.5070104@cogentembedded.com>
References: <1392265339-14841-1-git-send-email-liujunliang_ljl@163.com>
	<20140213.183237.1108958546198981160.davem@davemloft.net>
	<52FD6579.5070104@cogentembedded.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Thu, 13 Feb 2014 15:42:23 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Date: Fri, 14 Feb 2014 03:38:17 +0300

> Hello.
> 
> On 02/14/2014 02:32 AM, David Miller wrote:
> 
>>> From: Liu Junliang <liujunliang_ljl@163.com>
> 
>>> Signed-off-by: Liu Junliang <liujunliang_ljl@163.com>
> 
>> I think it's more canonical to specify no default at all.
> 
>    That's what he did, no?

Indeed, my bad, patch applied, thanks!
