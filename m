Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752974Ab3F2Ekj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Jun 2013 00:40:39 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:46287 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752151Ab3F2Ekh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Jun 2013 00:40:37 -0400
Date: Fri, 28 Jun 2013 21:40:36 -0700 (PDT)
Message-Id: <20130628.214036.771763171931363297.davem@davemloft.net>
To: dchang@suse.com
Cc: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org, jlee@suse.com
Subject: Re: [PATCH 2/2 net-next] usbnet: ax88179_178a: add .reset_resume
 hook
From: David Miller <davem@davemloft.net>
In-Reply-To: <1372324603-4556-2-git-send-email-dchang@suse.com>
References: <1372324603-4556-1-git-send-email-dchang@suse.com>
	<1372324603-4556-2-git-send-email-dchang@suse.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Chang <dchang@suse.com>
Date: Thu, 27 Jun 2013 17:16:43 +0800

> I tested with the AX88179 usb dongle, if without .reset_resume hook,
> after S3/S4 resume you have to enable network interface or reload the
> dirver module manually otherwise the network interface can not work.
> 
> Signed-off-by: David Chang <dchang@suse.com>

Applied.

