Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753333AbaEUVTl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 17:19:41 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:56136 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752687AbaEUVTk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 17:19:40 -0400
Date: Wed, 21 May 2014 17:19:37 -0400 (EDT)
Message-Id: <20140521.171937.898588239489051362.davem@davemloft.net>
To: julia.lawall@lip6.fr
Cc: sergei.shtylyov@cogentembedded.com, inaky.perez-gonzalez@intel.com,
        kernel-janitors@vger.kernel.org, linux-wimax@intel.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/13 v2] wimax/i2400m: make return of 0 explicit
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.DEB.2.10.1405200844010.2723@hadrien>
References: <1400473875-22228-5-git-send-email-Julia.Lawall@lip6.fr>
	<5379FD39.7020605@cogentembedded.com>
	<alpine.DEB.2.10.1405200844010.2723@hadrien>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 21 May 2014 14:19:39 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia.lawall@lip6.fr>
Date: Tue, 20 May 2014 08:44:49 +0800 (SGT)

> From: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> Delete unnecessary local variable whose value is always 0 and that hides
> the fact that the result is always 0.
> 
> A simplified version of the semantic patch that fixes this problem is as
> follows: (http://coccinelle.lip6.fr/)
 ...
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> ---
> Alternatively, is an error code wanted under the if?
> 
> v2: remove the use of 0 as an argument in the call to d_fnend

Applied to net-next, thanks.
