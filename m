Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754862AbaDKDLt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 23:11:49 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:46061 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751019AbaDKDLs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 23:11:48 -0400
Date: Thu, 10 Apr 2014 23:11:43 -0400 (EDT)
Message-Id: <20140410.231143.457143731030572105.davem@davemloft.net>
To: xiaoming.wang@intel.com
Cc: kuznet@ms2.inr.ac.ru, jmorris@namei.org, yoshfuji@linux-ipv6.org,
        kaber@trash.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        chuansheng.liu@intel.com, dongxing.zhang@intel.com
Subject: Re: [PATCH] net: ipv4: current group_info should be put after
 using.
From: David Miller <davem@davemloft.net>
In-Reply-To: <1397232638.20759.28.camel@wxm-ubuntu>
References: <1397232638.20759.28.camel@wxm-ubuntu>
X-Mailer: Mew version 6.5 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Thu, 10 Apr 2014 20:11:47 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Wang, Xiaoming" <xiaoming.wang@intel.com>
Date: Fri, 11 Apr 2014 12:10:38 -0400

> +EXIT:

Do not use all CAPS names for local labels.

Make the label, in lower case, say something about
what state needs to be released at that point.

Something like "out_release_group:"
