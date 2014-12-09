Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752054AbaLISlj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 13:41:39 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:37394 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751564AbaLISlh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 13:41:37 -0500
Date: Tue, 09 Dec 2014 13:41:35 -0500 (EST)
Message-Id: <20141209.134135.1917776346032039917.davem@davemloft.net>
To: hayeswang@realtek.com
Cc: netdev@vger.kernel.org, nic_swsd@realtek.com, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH net-next] r8152: redefine REALTEK_USB_DEVICE
From: David Miller <davem@davemloft.net>
In-Reply-To: <1394712342-15778-106-Taiwan-albertk@realtek.com>
References: <1394712342-15778-106-Taiwan-albertk@realtek.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 09 Dec 2014 10:41:37 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hayes Wang <hayeswang@realtek.com>
Date: Thu, 4 Dec 2014 10:43:11 +0800

> Redefine REALTEK_USB_DEVICE for the desired USB interface for probe().
> There are three USB interfaces for the device. USB_CLASS_COMM and
> USB_CLASS_CDC_DATA are for ECM mode (config #2). USB_CLASS_VENDOR_SPEC
> is for the vendor mode (config #1). However, we are not interesting
> in USB_CLASS_CDC_DATA for probe(), so redefine REALTEK_USB_DEVICE
> to ignore the USB interface class of USB_CLASS_CDC_DATA.
> 
> Signed-off-by: Hayes Wang <hayeswang@realtek.com>

Applied.
