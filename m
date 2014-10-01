Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751956AbaJAUrG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 16:47:06 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:36552 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751300AbaJAUrD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 16:47:03 -0400
Date: Wed, 01 Oct 2014 16:47:01 -0400 (EDT)
Message-Id: <20141001.164701.150693070220358210.davem@davemloft.net>
To: hayeswang@realtek.com
Cc: netdev@vger.kernel.org, nic_swsd@realtek.com, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH net 0/2] r8152: patches about firmware
From: David Miller <davem@davemloft.net>
In-Reply-To: <1394712342-15778-51-Taiwan-albertk@realtek.com>
References: <1394712342-15778-51-Taiwan-albertk@realtek.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 01 Oct 2014 13:47:03 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hayes Wang <hayeswang@realtek.com>
Date: Wed, 1 Oct 2014 13:25:09 +0800

> The patches fix the issues when the firmware exists.
> 
> For the multiple OS, the firmware may be loaded by the
> driver of the other OS. And the Linux driver has influences
> on it.

Series applied, thanks.
