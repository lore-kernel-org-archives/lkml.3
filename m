Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753496Ab3JYX1h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 19:27:37 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:36197 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751918Ab3JYX1f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 19:27:35 -0400
Date: Fri, 25 Oct 2013 19:27:34 -0400 (EDT)
Message-Id: <20131025.192734.1224686649926183282.davem@davemloft.net>
To: freddy@asix.com.tw
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, allan@asix.com.tw, louis@asix.com.tw
Subject: Re: [PATCH 1/1] ax88179_178a: Remove AX_MEDIUM_ALWAYS_ONE bit in
 AX_MEDIUM_STATUS_MODE register to avoid TX throttling
From: David Miller <davem@davemloft.net>
In-Reply-To: <1382597905-2393-1-git-send-email-freddy@asix.com.tw>
References: <1382597905-2393-1-git-send-email-freddy@asix.com.tw>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Fri, 25 Oct 2013 16:27:35 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: freddy@asix.com.tw
Date: Thu, 24 Oct 2013 14:58:25 +0800

> From: Freddy Xin <freddy@asix.com.tw>
> 
> Remove AX_MEDIUM_ALWAYS_ONE in AX_MEDIUM_STATUS_MODE register.
> Setting this bit may cause TX throttling in Half-Duplex mode.
> 
> Signed-off-by: Freddy Xin <freddy@asix.com.tw>

Applied.
