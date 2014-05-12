Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751750AbaELFDK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 01:03:10 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:54959 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751120AbaELFDI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 01:03:08 -0400
Date: Mon, 12 May 2014 01:03:06 -0400 (EDT)
Message-Id: <20140512.010306.302000625227507734.davem@davemloft.net>
To: haiyangz@microsoft.com
Cc: netdev@vger.kernel.org, kys@microsoft.com, olaf@aepfle.de,
        jasowang@redhat.com, linux-kernel@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org
Subject: Re: [PATCH net-next,v3] Add support for netvsc build without
 CONFIG_SYSFS flag
From: David Miller <davem@davemloft.net>
In-Reply-To: <1399587250-27846-1-git-send-email-haiyangz@microsoft.com>
References: <1399587250-27846-1-git-send-email-haiyangz@microsoft.com>
X-Mailer: Mew version 6.5 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Sun, 11 May 2014 22:03:08 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Haiyang Zhang <haiyangz@microsoft.com>
Date: Thu,  8 May 2014 15:14:10 -0700

> This change ensures the driver can be built successfully without the
> CONFIG_SYSFS flag.
> MS-TFS: 182270
> 
> Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> Reviewed-by: K. Y. Srinivasan <kys@microsoft.com>

Applied, thanks.
