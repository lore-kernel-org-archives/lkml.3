Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754654Ab3DKUXH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 16:23:07 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:38980 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753077Ab3DKUXE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 16:23:04 -0400
Date: Thu, 11 Apr 2013 16:23:02 -0400 (EDT)
Message-Id: <20130411.162302.1060976129520987073.davem@davemloft.net>
To: silviupopescu1990@gmail.com
Cc: netdev@vger.kernel.org, peppe.cavallaro@st.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: ethernet: stmicro: stmmac: use
 devm_ioremap_resource()
From: David Miller <davem@davemloft.net>
In-Reply-To: <1365709933-5796-1-git-send-email-silviupopescu1990@gmail.com>
References: <1365709933-5796-1-git-send-email-silviupopescu1990@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Thu, 11 Apr 2013 13:23:04 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Silviu-Mihai Popescu <silviupopescu1990@gmail.com>
Date: Thu, 11 Apr 2013 22:52:13 +0300

> Convert  use of devm_request_and_ioremap() to the newly introduced
> devm_ioremap_resource() which provides more consistent error handling.
> 
> devm_ioremap_resource() provides its own error messages so all explicit
> error messages can be removed from the failure code paths.
> 
> This was found with coccinelle.
> 
> Signed-off-by: Silviu-Mihai Popescu <silviupopescu1990@gmail.com>

Applied.
