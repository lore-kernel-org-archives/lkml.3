Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756656AbaKSU2H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 15:28:07 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:38416 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755749AbaKSU2E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 15:28:04 -0500
Date: Wed, 19 Nov 2014 15:28:01 -0500 (EST)
Message-Id: <20141119.152801.1458359057740370487.davem@davemloft.net>
To: elfring@users.sourceforge.net
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, cocci@systeme.lip6.fr
Subject: Re: [PATCH 1/1] netlink: Deletion of an unnecessary check before
 the function call "__module_get"
From: David Miller <davem@davemloft.net>
In-Reply-To: <546BA747.6000703@users.sourceforge.net>
References: <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6>
	<5317A59D.4@users.sourceforge.net>
	<546BA747.6000703@users.sourceforge.net>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 19 Nov 2014 12:28:04 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: SF Markus Elfring <elfring@users.sourceforge.net>
Date: Tue, 18 Nov 2014 21:08:39 +0100

> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Tue, 18 Nov 2014 21:03:13 +0100
> 
> The __module_get() function tests whether its argument is NULL and then
> returns immediately. Thus the test around the call is not needed.
> 
> This issue was detected by using the Coccinelle software.
> 
> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>

Applied, thanks.
