Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756855Ab3LWCZf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Dec 2013 21:25:35 -0500
Received: from rtits2.realtek.com ([60.250.210.242]:42384 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756362Ab3LWCZe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Dec 2013 21:25:34 -0500
X-SpamFilter-By: BOX Solutions SpamTrap 5.38 with qID rBN2O7gK006778, This message is accepted by code: ctloc85258
From: hayeswang <hayeswang@realtek.com>
To: "'Hayeswang'" <hayeswang@realtek.com>, <netdev@vger.kernel.org>
CC: "'nic_swsd'" <nic_swsd@realtek.com>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>
References: <1384502279-9959-1-git-send-email-hayeswang@realtek.com> <1384939857-13519-1-git-send-email-hayeswang@realtek.com>
Subject: RE: [PATCH net v5 0/4] r8152 bug fixes
Date: Mon, 23 Dec 2013 10:20:35 +0800
Message-ID: <7C579EF45BE74AFFB7218148FE7554F6@realtek.com.tw>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
Thread-Index: Ac7l0z3ZvcUhQZI/RdyR/dRMr4zUOQZsjJ0g
In-Reply-To: <1384939857-13519-1-git-send-email-hayeswang@realtek.com>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.6157
X-Originating-IP: [172.21.71.143]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Any response? 

> -----Original Message-----
> From: Hayeswang [mailto:hayeswang@realtek.com] 
> Sent: Wednesday, November 20, 2013 5:31 PM
> To: netdev@vger.kernel.org
> Cc: nic_swsd; linux-kernel@vger.kernel.org; 
> linux-usb@vger.kernel.org; Hayeswang
> Subject: [PATCH net v5 0/4] r8152 bug fixes
> 
> For the patch #3, I add netif_tx_lock() before checking the
> netif_queue_stopped(). Besides, I add checking the skb queue
> length before waking the tx queue.
> 
> Hayes Wang (4):
>   r8152: fix tx/rx memory overflow
>   r8152: modify the tx flow
>   r8152: support stopping/waking tx queue
>   r8152: fix incorrect type in assignment
> 
>  drivers/net/usb/r8152.c | 114 
> +++++++++++++++++++++---------------------------
>  1 file changed, 50 insertions(+), 64 deletions(-)
> 
> -- 
> 1.8.3.1
> 
> 

