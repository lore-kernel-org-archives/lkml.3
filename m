Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751998Ab3KSCcu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 21:32:50 -0500
Received: from rtits2.realtek.com ([60.250.210.242]:60660 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751788Ab3KSCcs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 21:32:48 -0500
X-SpamFilter-By: BOX Solutions SpamTrap 5.37 with qID rAJ2WfTu029237, This message is accepted by code: ctloc85258
From: hayeswang <hayeswang@realtek.com>
To: "'David Miller'" <davem@davemloft.net>
CC: <netdev@vger.kernel.org>, "'nic_swsd'" <nic_swsd@realtek.com>,
        <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>
References: <1384502279-9959-1-git-send-email-hayeswang@realtek.com><1384502279-9959-2-git-send-email-hayeswang@realtek.com> <20131115.173948.1712849813995511721.davem@davemloft.net>
Subject: RE: [PATCH net v3 1/4] r8152: fix tx/rx memory overflow
Date: Tue, 19 Nov 2013 10:32:47 +0800
Message-ID: <701E277A875F4A69A1B3C5B306B7CE8B@realtek.com.tw>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
Thread-Index: Ac7iU5tSrBrjMUG3Qw+kISqWbNxQKgCe4jgw
In-Reply-To: <20131115.173948.1712849813995511721.davem@davemloft.net>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.6157
X-Originating-IP: [172.21.71.143]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller [mailto:davem@davemloft.net] 
> Sent: Saturday, November 16, 2013 6:40 AM
> To: Hayeswang
> Cc: netdev@vger.kernel.org; nic_swsd; 
> linux-kernel@vger.kernel.org; linux-usb@vger.kernel.org
> Subject: Re: [PATCH net v3 1/4] r8152: fix tx/rx memory overflow
> 
> From: Hayes Wang <hayeswang@realtek.com>
> Date: Fri, 15 Nov 2013 15:57:56 +0800
> 
> > +			unsigned pkt_len;
> 
> Please fully specify the type as "unsigned int".  Please 
> check for this
> problem in the rest of your patches too.

I would fix it.

I check the other patches, and I don't find the same problem.

Thanks.
 
Best Regards,
Hayes

