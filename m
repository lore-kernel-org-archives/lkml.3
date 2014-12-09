Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756283AbaLIBY2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 20:24:28 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:59028 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751103AbaLIBY1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 20:24:27 -0500
Date: Mon, 08 Dec 2014 20:24:24 -0500 (EST)
Message-Id: <20141208.202424.1782433533296173544.davem@davemloft.net>
To: haiyangz@microsoft.com
Cc: netdev@vger.kernel.org, kys@microsoft.com, olaf@aepfle.de,
        jasowang@redhat.com, linux-kernel@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org
Subject: Re: [PATCH net-next] hyperv: Add support for vNIC hot removal
From: David Miller <davem@davemloft.net>
In-Reply-To: <1417469319-7356-1-git-send-email-haiyangz@microsoft.com>
References: <1417469319-7356-1-git-send-email-haiyangz@microsoft.com>
X-Mailer: Mew version 6.6 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 08 Dec 2014 17:24:26 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Haiyang Zhang <haiyangz@microsoft.com>
Date: Mon,  1 Dec 2014 13:28:39 -0800

> This patch adds proper handling of the vNIC hot removal event, which includes
> a rescind-channel-offer message from the host side that triggers vNIC close and
> removal. In this case, the notices to the host during close and removal is not
> necessary because the channel is rescinded. This patch blocks these unnecessary 
> messages, and lets vNIC removal process complete normally.
> 
> Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> Reviewed-by: K. Y. Srinivasan <kys@microsoft.com>

Applied, thanks.
