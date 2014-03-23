Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752592AbaCWRax (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2014 13:30:53 -0400
Received: from senator.holtmann.net ([87.106.208.187]:46513 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752520AbaCWRat convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2014 13:30:49 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 7.2 \(1874\))
Subject: Re: [patch 13/16] bt: hci-bcsp: Use del_timer_sync() in teardown path
From: Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20140323150754.030657558@linutronix.de>
Date: Sun, 23 Mar 2014 10:30:42 -0700
Cc: LKML <linux-kernel@vger.kernel.org>, Julia Lawall <Julia.Lawall@lip6.fr>,
        Andrew Morton <akpm@linux-foundation.org>,
        bt <linux-bluetooth@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <536E0DCB-B30E-45AF-A6F7-07FF4575A24A@holtmann.org>
References: <20140323150557.288925975@linutronix.de> <20140323150754.030657558@linutronix.de>
To: Thomas Gleixner <tglx@linutronix.de>
X-Mailer: Apple Mail (2.1874)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,

> Make sure no timer callback is running before freeing the
> datastructure which contains it.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: Marcel Holtmann <marcel@holtmann.org>
> Cc: bt <linux-bluetooth@vger.kernel.org>
> ---
> drivers/bluetooth/hci_bcsp.c |    2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)

we already fixed something similar in bluetooth-next tree. I think your patch is no longer needed.

Regards

Marcel

