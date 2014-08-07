Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755768AbaHGXFE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 19:05:04 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:53621 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752231AbaHGXFA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 19:05:00 -0400
Date: Thu, 07 Aug 2014 16:04:59 -0700 (PDT)
Message-Id: <20140807.160459.766871119996172680.davem@davemloft.net>
To: Julia.Lawall@lip6.fr
Cc: chas@cmf.nrl.navy.mil, kernel-janitors@vger.kernel.org,
        linux-atm-general@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/5] solos-pci: fix error return code
From: David Miller <davem@davemloft.net>
In-Reply-To: <1407415749-19978-4-git-send-email-Julia.Lawall@lip6.fr>
References: <1407415749-19978-1-git-send-email-Julia.Lawall@lip6.fr>
	<1407415749-19978-4-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Thu, 07 Aug 2014 16:05:00 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>
Date: Thu,  7 Aug 2014 14:49:07 +0200

> From: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> Convert a zero return value on error to a negative one, as returned
> elsewhere in the function.
> 
> A simplified version of the semantic match that finds this problem is as
> follows: (http://coccinelle.lip6.fr/)
 ...
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

Applied.
