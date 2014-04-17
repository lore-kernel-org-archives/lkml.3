Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752054AbaDQSQH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 14:16:07 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:57978 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751102AbaDQSPx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 14:15:53 -0400
Date: Thu, 17 Apr 2014 14:17:52 -0400 (EDT)
Message-Id: <20140417.141752.953673813169713717.davem@davemloft.net>
To: haiyangz@microsoft.com
Cc: netdev@vger.kernel.org, kys@microsoft.com, olaf@aepfle.de,
        jasowang@redhat.com, linux-kernel@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org
Subject: Re: [PATCH net-next,v4] hyperv: Add support for virtual Receive
 Side Scaling (vRSS)
From: David Miller <davem@davemloft.net>
In-Reply-To: <4d82d2d3960447cfade67174b03ec877@DFM-DB3MBX15-06.exchange.corp.microsoft.com>
References: <1396898623-31667-1-git-send-email-haiyangz@microsoft.com>
	<20140407.144258.2113005286706932770.davem@davemloft.net>
	<4d82d2d3960447cfade67174b03ec877@DFM-DB3MBX15-06.exchange.corp.microsoft.com>
X-Mailer: Mew version 6.4 on Emacs 23.4 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Thu, 17 Apr 2014 11:15:53 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Haiyang Zhang <haiyangz@microsoft.com>
Date: Thu, 17 Apr 2014 17:25:31 +0000

> Is the net-next tree open now? 

No, it is not.
