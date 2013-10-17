Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762680Ab3JQUB0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 16:01:26 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:46746 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758669Ab3JQUBY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 16:01:24 -0400
Date: Thu, 17 Oct 2013 16:01:21 -0400 (EDT)
Message-Id: <20131017.160121.1483822762826648122.davem@davemloft.net>
To: mrkiko.rs@gmail.com
Cc: gregkh@linuxfoundation.org, bjorn@mork.no, dcbw@redhat.com,
        christian.schmiedl@gemalto.com, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        anto.pellizzari83@gmail.com
Subject: Re: [PATCH] net: qmi_wwan: Olivetti Olicard 200 support
From: David Miller <davem@davemloft.net>
In-Reply-To: <1381842408-10800-2-git-send-email-mrkiko.rs@gmail.com>
References: <1381842408-10800-1-git-send-email-mrkiko.rs@gmail.com>
	<1381842408-10800-2-git-send-email-mrkiko.rs@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Thu, 17 Oct 2013 13:01:24 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Enrico Mioso <mrkiko.rs@gmail.com>
Date: Tue, 15 Oct 2013 15:06:48 +0200

> This is a QMI device, manufactured by TCT Mobile Phones.
> A companion patch blacklisting this device's QMI interface in the option.c
> driver has been sent.
> 
> Signed-off-by: Enrico Mioso <mrkiko.rs@gmail.com>
> Signed-off-by: Antonella Pellizzari <anto.pellizzari83@gmail.com>

Applied, thanks.
