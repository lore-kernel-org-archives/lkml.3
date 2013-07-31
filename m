Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760860Ab3GaVty (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 17:49:54 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:33491 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760796Ab3GaVtw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 17:49:52 -0400
Date: Wed, 31 Jul 2013 14:49:51 -0700 (PDT)
Message-Id: <20130731.144951.812145423086412978.davem@davemloft.net>
To: hayeswang@realtek.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH v4 2/5] net/usb/r815x: avoid to call mdio functions for
 runtime-suspended device
From: David Miller <davem@davemloft.net>
In-Reply-To: <1375262486-5373-2-git-send-email-hayeswang@realtek.com>
References: <D7C722C73C7A400780358D0376412267@realtek.com.tw>
	<1375262486-5373-1-git-send-email-hayeswang@realtek.com>
	<1375262486-5373-2-git-send-email-hayeswang@realtek.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Wed, 31 Jul 2013 14:49:51 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hayes Wang <hayeswang@realtek.com>
Date: Wed, 31 Jul 2013 17:21:23 +0800

> Don't replace the usb_control_msg() with usbnet_{read,write}_cmd()
> which couldn't be called inside suspend/resume callback. Keep the
> basic functions unlimited. Instead, using usb_autopm_get_interface()
> and usb_autopm_put_interface() in r815x_mdio_{read,write}().
> 
> Signed-off-by: Hayes Wang <hayeswang@realtek.com>

Applied.
