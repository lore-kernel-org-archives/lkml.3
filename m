Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762560Ab3ECDLz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 23:11:55 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:43297 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762525Ab3ECDLw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 23:11:52 -0400
X-SpamFilter-By: BOX Solutions SpamTrap 5.32 with qID r433BgND029202, This message is accepted by code: ctloc85258
From: hayeswang <hayeswang@realtek.com>
To: "'Greg KH'" <gregkh@linuxfoundation.org>
CC: <oliver@neukum.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        "'nic_swsd'" <nic_swsd@realtek.com>
References: <1366965948-1805-1-git-send-email-hayeswang@realtek.com> <1367546485-1619-1-git-send-email-hayeswang@realtek.com> <20130503023328.GB26712@kroah.com>
Subject: RE: [PATCH v3 net-next] net/usb: new driver for RTL8152
Date: Fri, 3 May 2013 11:11:47 +0800
Message-ID: <4215C45C849149B8A86B57F8D603AAEA@realtek.com.tw>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
Thread-Index: Ac5Hp/utytmtD+MiT1e6f25aqDuSwQAAdiMg
In-Reply-To: <20130503023328.GB26712@kroah.com>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.6157
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH [mailto:gregkh@linuxfoundation.org] 
> Sent: Friday, May 03, 2013 10:33 AM
> To: Hayeswang
> Cc: oliver@neukum.org; netdev@vger.kernel.org; 
> linux-kernel@vger.kernel.org; linux-usb@vger.kernel.org; nic_swsd
> Subject: Re: [PATCH v3 net-next] net/usb: new driver for RTL8152
> 
> On Fri, May 03, 2013 at 10:01:25AM +0800, Hayes Wang wrote:
> > Add new driver for supporting Realtek RTL8152 Based USB 2.0 
> Ethernet Adapters
> > 
> > Signed-off-by: Hayes Wang <hayeswang@realtek.com>
> > Cc: Realtek linux nic maintainers <nic_swsd@realtek.com>
> 
> You removed the wording I had questions about last time, does 
> that mean
> the previous wording was not correct, or that you no longer are
> publicising the fact that this driver reads on some patents that you
> own?
> 
> You also failed to answer my previous questions, why?

That description is about the patent for the hw design, not for software. It
indicates that the design of the hw uses those patents from the other compnay. I
have no idea about how to deal with those patents. What should I do for sending
a patch? 

Best Regards,
Hayes

