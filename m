Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751971AbaKKVZG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 16:25:06 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:33783 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751462AbaKKVZD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 16:25:03 -0500
Date: Tue, 11 Nov 2014 16:25:00 -0500 (EST)
Message-Id: <20141111.162500.469910623806405034.davem@davemloft.net>
To: sudipm.mukherjee@gmail.com
Cc: steve.glendinning@shawell.net, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] usbnet: smsc95xx: dereferencing NULL pointer
From: David Miller <davem@davemloft.net>
In-Reply-To: <1415695247-30442-1-git-send-email-sudipm.mukherjee@gmail.com>
References: <1415695247-30442-1-git-send-email-sudipm.mukherjee@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 11 Nov 2014 13:25:03 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Date: Tue, 11 Nov 2014 14:10:47 +0530

> we were dereferencing dev to initialize pdata. but just after that we
> have a BUG_ON(!dev). so we were basically dereferencing the pointer
> first and then tesing it for NULL.
> 
> Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>
> ---
> 
> change in v2: suspend_flags is initialised after pdata is initialised.
> v1 had a very silly but serious mistake of making pdata NULL, and trying
> to dereference it.
> sorry again for that.

This looks better, applied, thanks.
