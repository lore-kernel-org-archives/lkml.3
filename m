Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753457Ab3AWEPT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 23:15:19 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:60364 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752887Ab3AWEPR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 23:15:17 -0500
Date: Tue, 22 Jan 2013 23:15:15 -0500 (EST)
Message-Id: <20130122.231515.1276077448591402095.davem@davemloft.net>
To: freddy@asix.com.tw
Cc: netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, louis@asix.com.tw
Subject: Re: [PATCH, resubmit] ax88179_178a: ASIX AX88179_178A USB 3.0/2.0
 to gigabit ethernet adapter driver
From: David Miller <davem@davemloft.net>
In-Reply-To: <1358908337-13841-1-git-send-email-freddy@asix.com.tw>
References: <1358908337-13841-1-git-send-email-freddy@asix.com.tw>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Freddy Xin <freddy@asix.com.tw>
Date: Wed, 23 Jan 2013 10:32:17 +0800

> Fixed coding style errors.

There are still many style issues remaining, you have a lot more
work to do, for example:

> +	return fn(dev, cmd, USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
> +	       value, index, data, size);
> +

This empty line is unnecessary, get rid of it.

Also this function call is not indented properly.  The first character
on the second line of the fn() call should line up with the first
column after the openning parenthesis of the first line of the call.
