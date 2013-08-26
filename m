Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752569Ab3HZU6f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 16:58:35 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:41915 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751968Ab3HZU6d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 16:58:33 -0400
Date: Mon, 26 Aug 2013 16:58:31 -0400 (EDT)
Message-Id: <20130826.165831.112649899191508957.davem@davemloft.net>
To: joe@perches.com
Cc: mrkiko.rs@gmail.com, gregkh@linuxfoundation.org, oliver@neukum.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH RESEND V3 net-next 2/3] net: huawei_cdc_ncm: Introduce
 the huawei_cdc_ncm driver
From: David Miller <davem@davemloft.net>
In-Reply-To: <1377549913.1877.12.camel@joe-AO722>
References: <1377244590-8558-3-git-send-email-mrkiko.rs@gmail.com>
	<20130826.163125.1134768821551948034.davem@davemloft.net>
	<1377549913.1877.12.camel@joe-AO722>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Mon, 26 Aug 2013 13:58:33 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Mon, 26 Aug 2013 13:45:13 -0700

> I think the premise of local variable
> declaration by line length is flawed.

I disagree.

> It can't work when local variables are
> dependent on initialization order as
> above.

Move the initialization below the declarations.
