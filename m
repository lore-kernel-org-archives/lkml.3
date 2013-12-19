Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932105Ab3LSUDG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 15:03:06 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:35598 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751357Ab3LSUDE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 15:03:04 -0500
Date: Thu, 19 Dec 2013 15:03:01 -0500 (EST)
Message-Id: <20131219.150301.1452969308105598247.davem@davemloft.net>
To: fanwlexca@gmail.com
Cc: michael.opdenacker@free-electrons.com, gaofeng@cn.fujitsu.com,
        akpm@linux-foundation.org, t.sailer@alumni.ethz.ch,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/net/hamradio: Integer overflow in
 hdlcdrv_ioctl()
From: David Miller <davem@davemloft.net>
In-Reply-To: <1387250728-10795-1-git-send-email-fanwlexca@gmail.com>
References: <1387250728-10795-1-git-send-email-fanwlexca@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Thu, 19 Dec 2013 12:03:03 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wenliang Fan <fanwlexca@gmail.com>
Date: Tue, 17 Dec 2013 11:25:28 +0800

> The local variable 'bi' comes from userspace. If userspace passed a
> large number to 'bi.data.calibrate', there would be an integer overflow
> in the following line:
> 	s->hdlctx.calibrate = bi.data.calibrate * s->par.bitrate / 16;
> 
> Signed-off-by: Wenliang Fan <fanwlexca@gmail.com>

Applied and queued up for -stable, thanks.
