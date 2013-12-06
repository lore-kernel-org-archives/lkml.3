Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753062Ab3LFQqI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 11:46:08 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:39943 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751130Ab3LFQqG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 11:46:06 -0500
Date: Fri, 06 Dec 2013 11:46:02 -0500 (EST)
Message-Id: <20131206.114602.2053541753179744731.davem@davemloft.net>
To: linux@roeck-us.net
Cc: zwu.kernel@gmail.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        wuzhy@linux.vnet.ibm.com
Subject: Re: [net-next PATCH 3/6] macvtap: remove the dead branch
From: David Miller <davem@davemloft.net>
In-Reply-To: <52A169D4.4060209@roeck-us.net>
References: <1386282527-14094-1-git-send-email-zwu.kernel@gmail.com>
	<1386282527-14094-4-git-send-email-zwu.kernel@gmail.com>
	<52A169D4.4060209@roeck-us.net>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Fri, 06 Dec 2013 08:46:06 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Guenter Roeck <linux@roeck-us.net>
Date: Thu, 05 Dec 2013 22:08:20 -0800

> Assigning the function's return value to ret just to ignore it seems
> odd.
> 
> Might make sense to change the function type to void.

That's exactly what his very next patch does, undoubtedly the two
patches should be combined into one.
