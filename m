Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752655AbaKUUO5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 15:14:57 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:38454 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751848AbaKUUOt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 15:14:49 -0500
Date: Fri, 21 Nov 2014 15:14:47 -0500 (EST)
Message-Id: <20141121.151447.331538308069301463.davem@davemloft.net>
To: elfring@users.sourceforge.net
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, julia.lawall@lip6.fr
Subject: Re: [PATCH 1/1] IBM-EMAC: Deletion of unnecessary checks before
 the function call "of_dev_put"
From: David Miller <davem@davemloft.net>
In-Reply-To: <546DEC79.9050807@users.sourceforge.net>
References: <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6>
	<5317A59D.4@users.sourceforge.net>
	<546DEC79.9050807@users.sourceforge.net>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Fri, 21 Nov 2014 12:14:49 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: SF Markus Elfring <elfring@users.sourceforge.net>
Date: Thu, 20 Nov 2014 14:28:25 +0100

> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Thu, 20 Nov 2014 14:22:47 +0100
> 
> The of_dev_put() function tests whether its argument is NULL and then
> returns immediately. Thus the test around the call is not needed.
> 
> This issue was detected by using the Coccinelle software.
> 
> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>

Applied.
