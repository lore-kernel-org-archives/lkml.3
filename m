Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935189AbaLLUbZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 15:31:25 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:38227 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932702AbaLLUbY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 15:31:24 -0500
Date: Fri, 12 Dec 2014 15:31:21 -0500 (EST)
Message-Id: <20141212.153121.2126874023661472965.davem@davemloft.net>
To: elfring@users.sourceforge.net
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, julia.lawall@lip6.fr
Subject: Re: [PATCH 1/1] IDE: Deletion of an unnecessary check before the
 function call "module_put"
From: David Miller <davem@davemloft.net>
In-Reply-To: <546F91E5.60104@users.sourceforge.net>
References: <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6>
	<5317A59D.4@users.sourceforge.net>
	<546F91E5.60104@users.sourceforge.net>
X-Mailer: Mew version 6.6 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Fri, 12 Dec 2014 12:31:24 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: SF Markus Elfring <elfring@users.sourceforge.net>
Date: Fri, 21 Nov 2014 20:26:29 +0100

> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Fri, 21 Nov 2014 20:22:32 +0100
> 
> The module_put() function tests whether its argument is NULL and then
> returns immediately. Thus the test around the call is not needed.
> 
> This issue was detected by using the Coccinelle software.
> 
> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>

Applied.
