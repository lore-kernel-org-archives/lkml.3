Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754115AbaHAFIL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 01:08:11 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:54308 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753420AbaHAFIH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 01:08:07 -0400
Date: Thu, 31 Jul 2014 22:08:06 -0700 (PDT)
Message-Id: <20140731.220806.404506771081570403.davem@davemloft.net>
To: freddy@asix.com.tw
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, louis@asix.com.tw
Subject: Re: [PATCH 1/1] AX88179_178A: Add ethtool ops for EEE support
From: David Miller <davem@davemloft.net>
In-Reply-To: <1406804795-2754-1-git-send-email-freddy@asix.com.tw>
References: <1406804795-2754-1-git-send-email-freddy@asix.com.tw>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Thu, 31 Jul 2014 22:08:06 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: freddy@asix.com.tw
Date: Thu, 31 Jul 2014 19:06:35 +0800

> From: Freddy Xin <freddy@asix.com.tw>
> 
> Add functions to support ethtool EEE manipulating, and the EEE
> is disabled in default setting to enhance the compatibility
> with certain switch.
> 
> Signed-off-by: Freddy Xin <freddy@asix.com.tw>

Applied, thanks.
