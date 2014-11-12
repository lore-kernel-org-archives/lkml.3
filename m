Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753621AbaKLVWF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 16:22:05 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:46867 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753307AbaKLVWE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 16:22:04 -0500
Date: Wed, 12 Nov 2014 16:21:52 -0500 (EST)
Message-Id: <20141112.162152.2094776975747538960.davem@davemloft.net>
To: haiyangz@microsoft.com
Cc: netdev@vger.kernel.org, kys@microsoft.com, olaf@aepfle.de,
        jasowang@redhat.com, linux-kernel@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org
Subject: Re: [PATCH net-next,v2] hyperv: Add processing of MTU reduced by
 the host
From: David Miller <davem@davemloft.net>
In-Reply-To: <1415830064-1440-1-git-send-email-haiyangz@microsoft.com>
References: <1415830064-1440-1-git-send-email-haiyangz@microsoft.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 12 Nov 2014 13:22:03 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Haiyang Zhang <haiyangz@microsoft.com>
Date: Wed, 12 Nov 2014 14:07:44 -0800

> If the host uses packet encapsulation feature, the MTU may be reduced by the
> host due to headroom reservation for encapsulation. This patch handles this
> new MTU value.
> 
> Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>

Applied, thanks for adding the comment.
