Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752845Ab3JaFwu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 01:52:50 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:50072 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750880Ab3JaFws (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 01:52:48 -0400
X-SpamFilter-By: BOX Solutions SpamTrap 5.37 with qID r9V5qd7I004136, This message is accepted by code: ctloc85258
From: hayeswang <hayeswang@realtek.com>
To: "'David Miller'" <davem@davemloft.net>
CC: <netdev@vger.kernel.org>, "'nic_swsd'" <nic_swsd@realtek.com>,
        <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>
References: <1383033377-1178-1-git-send-email-hayeswang@realtek.com><1383117220-893-1-git-send-email-hayeswang@realtek.com><1383117220-893-3-git-send-email-hayeswang@realtek.com> <20131030.170441.2031802071448773661.davem@davemloft.net>
Subject: RE: [PATCH net v2 2/3] r8152: modify the tx flow
Date: Thu, 31 Oct 2013 13:52:38 +0800
Message-ID: <3FC2D94481C34A40A55B033CB9CFA9FB@realtek.com.tw>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
Thread-Index: Ac7Vs6yhmlOX1ddmRJuFlzjw+C+C2QAOGaSw
In-Reply-To: <20131030.170441.2031802071448773661.davem@davemloft.net>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.6157
X-Originating-IP: [172.21.71.143]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Miller [mailto:davem@davemloft.net] 
Sent: Thursday, October 31, 2013 5:05 AM
> 
> From: Hayes Wang <hayeswang@realtek.com>
> Date: Wed, 30 Oct 2013 15:13:39 +0800
[...]
> Basically, your driver will now queue up to 1,000 packets onto
> this tx_queue list, because that is what tx_queue_len will be
> for alloc_etherdev() allocated network devices.
> 
> In my previous reply to you about this patch, I asked you to
> quantify and study the effects of using a limit of 60.  I said
> that 60 might be too large.
> 
> You've responded by removing the limit completely, which is exactly
> the opposite of what I've asked you to do.  Why did you do this?

Excuse me. My question is that the original code doesn't stop the tx queue
either, so I don't understand why it is necessary for this patch.

I don't say I wouldn't find the suitable value for the tx queue length.
I feel I need some time to think how to find the reasonable value. And
I don't hope it influences the submission of the other patches, so I
remove it first. Or, may I submit the other two patches first?

