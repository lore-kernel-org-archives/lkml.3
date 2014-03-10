Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753735AbaCJUQ6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 16:16:58 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:47071 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752568AbaCJUQ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 16:16:56 -0400
Date: Mon, 10 Mar 2014 16:16:53 -0400 (EDT)
Message-Id: <20140310.161653.166084311676254585.davem@davemloft.net>
To: haiyangz@microsoft.com
Cc: netdev@vger.kernel.org, kys@microsoft.com, olaf@aepfle.de,
        jasowang@redhat.com, linux-kernel@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org
Subject: Re: [PATCH net-next] hyperv: Change the receive buffer size for
 legacy hosts
From: David Miller <davem@davemloft.net>
In-Reply-To: <1394406659-22493-1-git-send-email-haiyangz@microsoft.com>
References: <1394406659-22493-1-git-send-email-haiyangz@microsoft.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 10 Mar 2014 13:16:56 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Haiyang Zhang <haiyangz@microsoft.com>
Date: Sun,  9 Mar 2014 16:10:59 -0700

> Due to a bug in the Hyper-V host verion 2008R2, we need to use a slightly smaller
> receive buffer size, otherwise the buffer will not be accepted by the legacy hosts.
> 
> Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>

Applied.
