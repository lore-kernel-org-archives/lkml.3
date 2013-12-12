Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751956Ab3LLAy3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 19:54:29 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:60787 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751155Ab3LLAyY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 19:54:24 -0500
Date: Wed, 11 Dec 2013 19:54:22 -0500 (EST)
Message-Id: <20131211.195422.656690100606056071.davem@davemloft.net>
To: olof@lixom.net
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org
Subject: Re: [PATCH 2/2] net: eth: davinci_cpdma: Mark a local variable
 static
From: David Miller <davem@davemloft.net>
In-Reply-To: <1386805882-25360-2-git-send-email-olof@lixom.net>
References: <1386805882-25360-1-git-send-email-olof@lixom.net>
	<1386805882-25360-2-git-send-email-olof@lixom.net>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Wed, 11 Dec 2013 16:54:23 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Olof Johansson <olof@lixom.net>
Date: Wed, 11 Dec 2013 15:51:21 -0800

> Only used locally. Found by sparse.
> 
> Signed-off-by: Olof Johansson <olof@lixom.net>

Applied.
