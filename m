Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755939Ab3AVU3k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 15:29:40 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:56574 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755813Ab3AVU3j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 15:29:39 -0500
Date: Tue, 22 Jan 2013 15:29:37 -0500 (EST)
Message-Id: <20130122.152937.698328122484839991.davem@davemloft.net>
To: msw@amazon.com
Cc: linux-kernel@vger.kernel.org, ian.campbell@citrix.com,
        netdev@vger.kernel.org, xen-devel@lists.xen.org,
        konrad.wilk@oracle.com
Subject: Re: [PATCH v2] xen-netback: allow changing the MAC address of the
 interface
From: David Miller <davem@davemloft.net>
In-Reply-To: <1358878105-7890-1-git-send-email-msw@amazon.com>
References: <1358878105-7890-1-git-send-email-msw@amazon.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matt Wilson <msw@amazon.com>
Date: Tue, 22 Jan 2013 18:08:25 +0000

> Sometimes it is useful to be able to change the MAC address of the
> interface for netback devices. For example, when using ebtables it may
> be useful to be able to distinguish traffic from different interfaces
> without depending on the interface name.
> 
> Reported-by: Nikita Borzykh <sample.n@gmail.com>
> Reported-by: Paul Harvey <stockingpaul@hotmail.com>
> Cc: netdev@vger.kernel.org
> Cc: xen-devel@lists.xen.org
> Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> Acked-by: Ian Campbell <ian.campbell@citrix.com>
> Signed-off-by: Matt Wilson <msw@amazon.com>

Applied to net-next, thanks.
