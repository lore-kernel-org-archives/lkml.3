Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757560AbaDWStW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 14:49:22 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:50763 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756049AbaDWStR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 14:49:17 -0400
Date: Wed, 23 Apr 2014 14:49:15 -0400 (EDT)
Message-Id: <20140423.144915.1738972094534966250.davem@davemloft.net>
To: haiyangz@microsoft.com
Cc: netdev@vger.kernel.org, kys@microsoft.com, olaf@aepfle.de,
        jasowang@redhat.com, linux-kernel@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org
Subject: Re: [PATCH net-next,v2,2/2] hyperv: Simplify the send_completion
 variables
From: David Miller <davem@davemloft.net>
In-Reply-To: <1398117284-5236-2-git-send-email-haiyangz@microsoft.com>
References: <1398117284-5236-1-git-send-email-haiyangz@microsoft.com>
	<1398117284-5236-2-git-send-email-haiyangz@microsoft.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 23 Apr 2014 11:49:17 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Haiyang Zhang <haiyangz@microsoft.com>
Date: Mon, 21 Apr 2014 14:54:44 -0700

> The union contains only one member now, so we use the variables in it directly.
> 
> Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> Reviewed-by: K. Y. Srinivasan <kys@microsoft.com>

Also applied, thanks.
