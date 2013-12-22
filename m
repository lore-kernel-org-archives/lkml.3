Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752477Ab3LVDXa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Dec 2013 22:23:30 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:48724 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751035Ab3LVDX2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Dec 2013 22:23:28 -0500
Date: Sat, 21 Dec 2013 22:23:26 -0500 (EST)
Message-Id: <20131221.222326.1085440987383472695.davem@davemloft.net>
To: haiyangz@microsoft.com
Cc: netdev@vger.kernel.org, kys@microsoft.com, olaf@aepfle.de,
        jasowang@redhat.com, linux-kernel@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org
Subject: Re: [PATCH net] hyperv: Fix race between probe and open calls
From: David Miller <davem@davemloft.net>
In-Reply-To: <1387587151-1508-1-git-send-email-haiyangz@microsoft.com>
References: <1387587151-1508-1-git-send-email-haiyangz@microsoft.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Sat, 21 Dec 2013 19:23:28 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Haiyang Zhang <haiyangz@microsoft.com>
Date: Fri, 20 Dec 2013 16:52:31 -0800

> Moving the register_netdev to the end of probe to prevent
> possible open call happens before NetVSP is connected.
> 
> Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> Reviewed-by: K. Y. Srinivasan <kys@microsoft.com>

Applied, thanks.
