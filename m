Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752907AbaGICzw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 22:55:52 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:55991 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751104AbaGICzu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 22:55:50 -0400
Date: Tue, 08 Jul 2014 19:55:49 -0700 (PDT)
Message-Id: <20140708.195549.779368337637597360.davem@davemloft.net>
To: hayeswang@realtek.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH net] r8152: wake up the device before dumping the hw
 counter
From: David Miller <davem@davemloft.net>
In-Reply-To: <1394712342-15778-5-Taiwan-albertk@realtek.com>
References: <1394712342-15778-5-Taiwan-albertk@realtek.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 08 Jul 2014 19:55:50 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hayes Wang <hayeswang@realtek.com>
Date: Tue, 8 Jul 2014 14:49:28 +0800

> The device should be waked up from runtime suspend before dumping
> the hw counter.
> 
> Signed-off-by: Hayes Wang <hayeswang@realtek.com>

Applied, thanks.
