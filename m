Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752126AbaBGEjy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 23:39:54 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:39953 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751728AbaBGEjv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 23:39:51 -0500
Date: Thu, 06 Feb 2014 20:39:50 -0800 (PST)
Message-Id: <20140206.203950.905861192240833461.davem@davemloft.net>
To: hayeswang@realtek.com
Cc: netdev@vger.kernel.org, nic_swsd@realtek.com, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH net] r8152: fix the submission of the interrupt transfer
From: David Miller <davem@davemloft.net>
In-Reply-To: <1391658948-4456-1-git-send-email-hayeswang@realtek.com>
References: <1391658948-4456-1-git-send-email-hayeswang@realtek.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hayes Wang <hayeswang@realtek.com>
Date: Thu, 6 Feb 2014 11:55:48 +0800

> The submission of the interrupt transfer should be done after setting
> the bit of WORK_ENABLE, otherwise the callback function would have
> the opportunity to be returned directly.
> 
> Clear the bit of WORK_ENABLE before killing the interrupt transfer.
> 
> Signed-off-by: Hayes Wang <hayeswang@realtek.com>

Applied.
