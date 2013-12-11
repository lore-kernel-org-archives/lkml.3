Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751570Ab3LKRQT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 12:16:19 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:58144 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750922Ab3LKRQQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 12:16:16 -0500
Date: Wed, 11 Dec 2013 12:16:12 -0500 (EST)
Message-Id: <20131211.121612.1818249304919726954.davem@davemloft.net>
To: freddy@asix.com.tw
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, louis@asix.com.tw, allan@asix.com.tw
Subject: Re: [PATCH 1/1] AX88179_178A: Enable the hardware pseudo header in
 case of the NET_IP_ALIGN equals 0
From: David Miller <davem@davemloft.net>
In-Reply-To: <52A80397.2080508@asix.com.tw>
References: <1386323898-2246-1-git-send-email-freddy@asix.com.tw>
	<20131209.200131.1376169274733452706.davem@davemloft.net>
	<52A80397.2080508@asix.com.tw>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Wed, 11 Dec 2013 09:16:16 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Freddy Xin <freddy@asix.com.tw>
Date: Wed, 11 Dec 2013 14:17:59 +0800

> I think there is no way of undoing the reservation in the driver.

Then you should add a flag that, indeed, tells usbnet not to do the
reservation in the first place.
