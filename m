Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935139Ab3FSTSG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 15:18:06 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:41775 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935074Ab3FSTSD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 15:18:03 -0400
Date: Wed, 19 Jun 2013 12:18:02 -0700 (PDT)
Message-Id: <20130619.121802.2112053686285060471.davem@davemloft.net>
To: steve.moorby@ntlworld.com
Cc: jiri@resnulli.us, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] drivers/net: param for lapbether for specific
 ethernet device
From: David Miller <davem@davemloft.net>
In-Reply-To: <1371655613-31969-1-git-send-email-steve.moorby@ntlworld.com>
References: <1371655613-31969-1-git-send-email-steve.moorby@ntlworld.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Moorby <steve.moorby@ntlworld.com>
Date: Wed, 19 Jun 2013 16:26:53 +0100

> The lapbether driver binds to the first ethernet device that comes up.
> This causes problems in hardware with multiple ethernet interfaces,
> potentially resulting in the LAPB traffic on the wrong interface.
> Have added a module parameter 'eth_dev' to specify the ethernet
> interface over which lapbether should operate.  The module behaves
> as before if no device is specified.
> 
> Patch created on linux-next 18-Jun-2013.
> Tested on 2.6.32-45-generic.
> 
> Signed-off-by: Stephen Moorby <steve.moorby@ntlworld.com>

I rejected this patch last night, stating that module parameters are
deeply discouraged and therefore you need to create a runtime mechanism
to control this.
