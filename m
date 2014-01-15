Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752819AbaAOVoA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 16:44:00 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:39973 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752226AbaAOVn6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 16:43:58 -0500
Date: Wed, 15 Jan 2014 13:43:52 -0800 (PST)
Message-Id: <20140115.134352.667699585785584026.davem@davemloft.net>
To: Julia.Lawall@lip6.fr
Cc: netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] ksz884x: delete useless variable
From: David Miller <davem@davemloft.net>
In-Reply-To: <1389629847-5330-2-git-send-email-Julia.Lawall@lip6.fr>
References: <1389629847-5330-1-git-send-email-Julia.Lawall@lip6.fr>
	<1389629847-5330-2-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>
Date: Mon, 13 Jan 2014 17:17:24 +0100

> From: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> Delete a variable that is at most only assigned to a constant, but never
> used otherwise.  In this code, it is the variable result that is used for
> the return code, not rc.
> 
> A simplified version of the semantic patch that fixes this problem is as
> follows: (http://coccinelle.lip6.fr/)
 ...
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

Applied, thank you.
