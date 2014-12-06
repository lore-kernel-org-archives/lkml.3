Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752137AbaLFFKi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2014 00:10:38 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:60146 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751150AbaLFFKg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2014 00:10:36 -0500
Date: Fri, 05 Dec 2014 21:15:06 -0800 (PST)
Message-Id: <20141205.211506.1876864218962612094.davem@davemloft.net>
To: elfring@users.sourceforge.net
Cc: olof@lixom.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, julia.lawall@lip6.fr
Subject: Re: [PATCH 1/1] net-PA Semi: Deletion of unnecessary checks before
 the function call "pci_dev_put"
From: David Miller <davem@davemloft.net>
In-Reply-To: <547A09B1.9090102@users.sourceforge.net>
References: <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6>
	<5317A59D.4@users.sourceforge.net>
	<547A09B1.9090102@users.sourceforge.net>
X-Mailer: Mew version 6.4 on Emacs 23.4 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Fri, 05 Dec 2014 21:10:36 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: SF Markus Elfring <elfring@users.sourceforge.net>
Date: Sat, 29 Nov 2014 19:00:17 +0100

> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Sat, 29 Nov 2014 18:55:40 +0100
> 
> The pci_dev_put() function tests whether its argument is NULL
> and then returns immediately. Thus the test around the call
> is not needed.
> 
> This issue was detected by using the Coccinelle software.
> 
> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>

Applied.
