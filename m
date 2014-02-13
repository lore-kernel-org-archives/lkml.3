Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752819AbaBMXcl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 18:32:41 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:51405 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752547AbaBMXcj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 18:32:39 -0500
Date: Thu, 13 Feb 2014 18:32:37 -0500 (EST)
Message-Id: <20140213.183237.1108958546198981160.davem@davemloft.net>
To: liujunliang_ljl@163.com
Cc: thierry.reding@gmail.com, horms@verge.net.au, joe@perches.com,
        romieu@fr.zoreil.com, gregkh@linuxfoundation.org,
        netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, sunhecheng@vip.126.com
Subject: Re: [PATCH] Fix Default to 'y' for SR9800 Device Driver, setting
 to 'n'
From: David Miller <davem@davemloft.net>
In-Reply-To: <1392265339-14841-1-git-send-email-liujunliang_ljl@163.com>
References: <1392265339-14841-1-git-send-email-liujunliang_ljl@163.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Thu, 13 Feb 2014 15:32:39 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: liujunliang_ljl@163.com
Date: Thu, 13 Feb 2014 12:22:19 +0800

> From: Liu Junliang <liujunliang_ljl@163.com>
> 
> 
> Signed-off-by: Liu Junliang <liujunliang_ljl@163.com>

I think it's more canonical to specify no default at all.
