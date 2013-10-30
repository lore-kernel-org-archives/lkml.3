Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752826Ab3J3DEB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 23:04:01 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:45357 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751167Ab3J3DD7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 23:03:59 -0400
X-SpamFilter-By: BOX Solutions SpamTrap 5.37 with qID r9U33qxE026475, This message is accepted by code: ctloc85258
From: hayeswang <hayeswang@realtek.com>
To: "'David Miller'" <davem@davemloft.net>
CC: <netdev@vger.kernel.org>, "'nic_swsd'" <nic_swsd@realtek.com>,
        <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>
References: <1383033377-1178-1-git-send-email-hayeswang@realtek.com><1383033377-1178-3-git-send-email-hayeswang@realtek.com> <20131029.174936.13317032766742363.davem@davemloft.net>
Subject: RE: [PATCH net 2/3] r8152: modify the tx flow
Date: Wed, 30 Oct 2013 11:03:55 +0800
Message-ID: <7F69554959F74FA58AE07F06B9FCF029@realtek.com.tw>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
Thread-Index: Ac7U8MatCeNPEQL3RtmiqmrVsdaIcQAJIIkg
In-Reply-To: <20131029.174936.13317032766742363.davem@davemloft.net>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.6157
X-Originating-IP: [172.21.71.143]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 David Miller [mailto:davem@davemloft.net] 
> Sent: Wednesday, October 30, 2013 5:50 AM
> To: Hayeswang
> Cc: netdev@vger.kernel.org; nic_swsd; 
> linux-kernel@vger.kernel.org; linux-usb@vger.kernel.org
> Subject: Re: [PATCH net 2/3] r8152: modify the tx flow
> 
> From: Hayes Wang <hayeswang@realtek.com>
> Date: Tue, 29 Oct 2013 15:56:16 +0800
> 
> > Support stopping and waking tx queue. The maximum tx queue length
> > is 60.
> 
> What is so special about the number 60?  It seems arbitrary, and if
> it isn't arbitrary you haven't described why this value was choosen.

The value is arbitrary. I think it is better to stop tx when
queuing many packets, otherwise all the available memory may
be used for tx skb. The queue length could be any value or
unlimited if the memory is enough. Should I remove it?

> I've asked you politely last time around to significantly improve
> the quality of your commit messages, and you haven't done this at
> all.

I thought you indicated the last patch only and the others are clear enough.
I would improve them.

> I'm not applying any of these patches until your commit messages
> properly describe your changes completely.
> 

