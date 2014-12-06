Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751932AbaLFFKZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2014 00:10:25 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:60137 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751154AbaLFFKY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2014 00:10:24 -0500
Date: Fri, 05 Dec 2014 21:14:52 -0800 (PST)
Message-Id: <20141205.211452.873684925293554813.davem@davemloft.net>
To: elfring@users.sourceforge.net
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, cocci@systeme.lip6.fr
Subject: Re: [PATCH 1/1] net: cassini: Deletion of an unnecessary check
 before the function call "vfree"
From: David Miller <davem@davemloft.net>
In-Reply-To: <5479D2AD.9060704@users.sourceforge.net>
References: <5317A59D.4@users.sourceforge.net>
	<5479CD2A.9030009@users.sourceforge.net>
	<5479D2AD.9060704@users.sourceforge.net>
X-Mailer: Mew version 6.4 on Emacs 23.4 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Fri, 05 Dec 2014 21:10:23 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: SF Markus Elfring <elfring@users.sourceforge.net>
Date: Sat, 29 Nov 2014 15:05:33 +0100

> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Sat, 29 Nov 2014 14:34:59 +0100
> 
> The vfree() function performs also input parameter validation.
> Thus the test around the call is not needed.
> 
> This issue was detected by using the Coccinelle software.
> 
> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>

Applied.
