Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754443AbaFWVtd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 17:49:33 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:35383 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754328AbaFWVtc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 17:49:32 -0400
Date: Mon, 23 Jun 2014 14:49:30 -0700 (PDT)
Message-Id: <20140623.144930.2077608308662590493.davem@davemloft.net>
To: joe@perches.com
Cc: linux-kernel@vger.kernel.org, linux-atm-general@lists.sourceforge.net,
        netdev@vger.kernel.org, iss_storagedev@hp.com,
        linux-crypto@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-rdma@vger.kernel.org, linux-media@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-eata@i-connect.net, devel@driverdev.osuosl.org,
        linux-arch@vger.kernel.org
Subject: Re: [PATCH 00/22] Add and use pci_zalloc_consistent
From: David Miller <davem@davemloft.net>
In-Reply-To: <cover.1403530604.git.joe@perches.com>
References: <cover.1403530604.git.joe@perches.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 23 Jun 2014 14:49:31 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Mon, 23 Jun 2014 06:41:28 -0700

> Adding the helper reduces object code size as well as overall
> source size line count.
> 
> It's also consistent with all the various zalloc mechanisms
> in the kernel.
> 
> Done with a simple cocci script and some typing.

For networking bits:

Acked-by: David S. Miller <davem@davemloft.net>
