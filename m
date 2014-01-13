Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752504AbaAMTTj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 14:19:39 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:38000 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752046AbaAMTTh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 14:19:37 -0500
Date: Mon, 13 Jan 2014 11:19:36 -0800 (PST)
Message-Id: <20140113.111936.1286616042680494607.davem@davemloft.net>
To: hayeswang@realtek.com
Cc: oliver@neukum.org, netdev@vger.kernel.org, nic_swsd@realtek.com,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH net-next 3/3] r8152: add supporting the vendor mode only
From: David Miller <davem@davemloft.net>
In-Reply-To: <1389250232-8663-4-git-send-email-hayeswang@realtek.com>
References: <1389250232-8663-1-git-send-email-hayeswang@realtek.com>
	<1389250232-8663-4-git-send-email-hayeswang@realtek.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hayes Wang <hayeswang@realtek.com>
Date: Thu, 9 Jan 2014 14:50:32 +0800

> Remove the limitation that the ecm and r8152 drivers couldn't coexist.
> Besides, add the feature to support the vendor mode only. This let
> someone who doesn't want to use ecm driver easy to use the vendor
> driver without creating the udev rule.
> 
> Signed-off-by: Hayes Wang <hayeswang@realtek.com>

This is a very bad precedence and I do not want drivers to start doing
things like this.

I think it would be wiser to use the existing facilities which exist
to control this situation, and yes udev is one of them.

I'm sorry, I'm not applying this series as long as it has this patch
in it.
