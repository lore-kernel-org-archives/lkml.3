Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752725AbaBTAxr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 19:53:47 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:49165 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751638AbaBTAxq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 19:53:46 -0500
Date: Wed, 19 Feb 2014 19:53:44 -0500 (EST)
Message-Id: <20140219.195344.2030120267225564200.davem@davemloft.net>
To: haiyangz@microsoft.com
Cc: netdev@vger.kernel.org, kys@microsoft.com, olaf@aepfle.de,
        jasowang@redhat.com, linux-kernel@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org
Subject: Re: [PATCH net-next,v2] hyperv: Add latest NetVSP versions to auto
 negotiation
From: David Miller <davem@davemloft.net>
In-Reply-To: <1392853785-2492-1-git-send-email-haiyangz@microsoft.com>
References: <1392853785-2492-1-git-send-email-haiyangz@microsoft.com>
X-Mailer: Mew version 6.5 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 19 Feb 2014 16:53:46 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Haiyang Zhang <haiyangz@microsoft.com>
Date: Wed, 19 Feb 2014 15:49:45 -0800

> It auto negotiates the highest NetVSP version supported by both guest and host.
> 
> Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> Reviewed-by: K. Y. Srinivasan <kys@microsoft.com>

Applied, thanks.
