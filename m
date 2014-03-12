Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752126AbaCLT2u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 15:28:50 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:40481 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751865AbaCLT2s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 15:28:48 -0400
Date: Wed, 12 Mar 2014 15:28:46 -0400 (EDT)
Message-Id: <20140312.152846.428352183871077637.davem@davemloft.net>
To: joe@perches.com
Cc: netdev@vger.kernel.org, alex.bluesman.smirnov@gmail.com,
        dbaryshkov@gmail.com, linux-zigbee-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 4/6] ieee802154: Convert uses of
 __constant_<foo> to <foo>
From: David Miller <davem@davemloft.net>
In-Reply-To: <5e8be8d647e70ad422eb686d315f93b3e265e9c6.1394643455.git.joe@perches.com>
References: <cover.1394643455.git.joe@perches.com>
	<5e8be8d647e70ad422eb686d315f93b3e265e9c6.1394643455.git.joe@perches.com>
X-Mailer: Mew version 6.5 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 12 Mar 2014 12:28:48 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Wed, 12 Mar 2014 10:04:18 -0700

> The use of __constant_<foo> has been unnecessary for quite awhile now.
> 
> Make these uses consistent with the rest of the kernel.
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Applied.
