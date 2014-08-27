Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965224AbaH0XSb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 19:18:31 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:41674 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933980AbaH0XS3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 19:18:29 -0400
Date: Wed, 27 Aug 2014 16:18:26 -0700 (PDT)
Message-Id: <20140827.161826.1147649707339837730.davem@davemloft.net>
To: hayeswang@realtek.com
Cc: netdev@vger.kernel.org, nic_swsd@realtek.com, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH net-next] r8152: replace strncpy with strlcpy
From: David Miller <davem@davemloft.net>
In-Reply-To: <1394712342-15778-22-Taiwan-albertk@realtek.com>
References: <1394712342-15778-16-Taiwan-albertk@realtek.com>
	<1394712342-15778-22-Taiwan-albertk@realtek.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 27 Aug 2014 16:18:29 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hayes Wang <hayeswang@realtek.com>
Date: Tue, 26 Aug 2014 10:08:23 +0800

> Replace the strncpy with strlcpy, and use sizeof to determine the
> length.
> 
> Signed-off-by: Hayes Wang <hayeswang@realtek.com>

Applied, thanks.
