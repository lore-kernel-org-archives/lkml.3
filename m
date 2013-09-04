Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761817Ab3IDCfY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 22:35:24 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:53928 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761796Ab3IDCfV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 22:35:21 -0400
Date: Tue, 03 Sep 2013 22:35:19 -0400 (EDT)
Message-Id: <20130903.223519.2136569601170359857.davem@davemloft.net>
To: joe@perches.com
Cc: lindner_marek@yahoo.de, siwu@hrz.tu-chemnitz.de, ordex@autistici.org,
        b.a.t.m.a.n@lists.open-mesh.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] batman: Remove reference to compare_ether_addr
From: David Miller <davem@davemloft.net>
In-Reply-To: <1378075508.1953.27.camel@joe-AO722>
References: <1378075508.1953.27.camel@joe-AO722>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Tue, 03 Sep 2013 19:35:20 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Sun, 01 Sep 2013 15:45:08 -0700

> This function is being removed, rename the reference.
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Applied.
