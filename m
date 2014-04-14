Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753240AbaDNCyN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2014 22:54:13 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:49450 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750779AbaDNCyM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2014 22:54:12 -0400
Date: Sun, 13 Apr 2014 22:54:07 -0400 (EDT)
Message-Id: <20140413.225407.1762639913754561393.davem@davemloft.net>
To: xiaoming.wang@intel.com
Cc: kuznet@ms2.inr.ac.ru, jmorris@namei.org, yoshfuji@linux-ipv6.org,
        kaber@trash.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        mguzik@redhat.com, chuansheng.liu@intel.com, dongxing.zhang@intel.com
Subject: Re: [PATCH] net: ipv4: current group_info should be put after
 using.
From: David Miller <davem@davemloft.net>
In-Reply-To: <1397493045.2575.8.camel@wxm-ubuntu>
References: <1397493045.2575.8.camel@wxm-ubuntu>
X-Mailer: Mew version 6.5 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Sun, 13 Apr 2014 19:54:11 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Wang, Xiaoming" <xiaoming.wang@intel.com>
Date: Mon, 14 Apr 2014 12:30:45 -0400

> Plug a group_info refcount leak in ping_init.
> group_info is only needed during initialization and 
> the code failed to release the reference on exit.
> While here move grabbing the reference to a place 
> where it is actually needed.
> 
> Signed-off-by: Chuansheng Liu <chuansheng.liu@intel.com>
> Signed-off-by: Zhang Dongxing <dongxing.zhang@intel.com>
> Signed-off-by: xiaoming wang <xiaoming.wang@intel.com>

Applied and queued up for -stable, thanks.
