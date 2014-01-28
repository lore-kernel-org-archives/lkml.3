Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754560AbaA1AlK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 19:41:10 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:38559 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753876AbaA1AlH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 19:41:07 -0500
Date: Mon, 27 Jan 2014 16:41:07 -0800 (PST)
Message-Id: <20140127.164107.224798942983026579.davem@davemloft.net>
To: haiyangz@microsoft.com
Cc: netdev@vger.kernel.org, kys@microsoft.com, olaf@aepfle.de,
        jasowang@redhat.com, linux-kernel@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org
Subject: Re: [PATCH net-next] hyperv: Add support for physically
 discontinuous receive buffer
From: David Miller <davem@davemloft.net>
In-Reply-To: <1390863822-3509-1-git-send-email-haiyangz@microsoft.com>
References: <1390863822-3509-1-git-send-email-haiyangz@microsoft.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Haiyang Zhang <haiyangz@microsoft.com>
Date: Mon, 27 Jan 2014 15:03:42 -0800

> This will allow us to use bigger receive buffer, and prevent allocation failure
> due to fragmented memory.
> 
> Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> Reviewed-by: K. Y. Srinivasan <kys@microsoft.com>

Applied, thanks.
