Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757354Ab3IKUPF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 16:15:05 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:46848 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755749Ab3IKUPC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 16:15:02 -0400
Date: Wed, 11 Sep 2013 16:14:59 -0400 (EDT)
Message-Id: <20130911.161459.589536168651227249.davem@davemloft.net>
To: michael.opdenacker@free-electrons.com
Cc: emilio@elopez.com.ar, mugunthanvnm@ti.com, jg1.han@samsung.com,
        hsweeten@visionengravers.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: korina: remove deprecated IRQF_DISABLED
From: David Miller <davem@davemloft.net>
In-Reply-To: <1378531257-5446-1-git-send-email-michael.opdenacker@free-electrons.com>
References: <1378531257-5446-1-git-send-email-michael.opdenacker@free-electrons.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Wed, 11 Sep 2013 13:15:02 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
Date: Sat,  7 Sep 2013 07:20:57 +0200

> This patch proposes to remove the IRQF_DISABLED flag from
> drivers/net/ethernet/korina.c
> 
> It's a NOOP since 2.6.35 and it will be removed one day.
> 
> Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>

Applied.
