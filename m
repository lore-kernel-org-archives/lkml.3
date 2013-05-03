Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751087Ab3ECEAz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 00:00:55 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:37095 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750739Ab3ECEAy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 00:00:54 -0400
Date: Fri, 03 May 2013 00:00:52 -0400 (EDT)
Message-Id: <20130503.000052.680733925880090504.davem@davemloft.net>
To: gregkh@linuxfoundation.org
Cc: hayeswang@realtek.com, oliver@neukum.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        nic_swsd@realtek.com
Subject: Re: [PATCH v3 net-next] net/usb: new driver for RTL8152
From: David Miller <davem@davemloft.net>
In-Reply-To: <20130503032315.GA22077@kroah.com>
References: <20130503023328.GB26712@kroah.com>
	<4215C45C849149B8A86B57F8D603AAEA@realtek.com.tw>
	<20130503032315.GA22077@kroah.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Thu, 02 May 2013 21:00:53 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: 'Greg KH' <gregkh@linuxfoundation.org>
Date: Thu, 2 May 2013 20:23:15 -0700

> On Fri, May 03, 2013 at 11:11:47AM +0800, hayeswang wrote:
>> Greg KH [mailto:gregkh@linuxfoundation.org] 
>> > Sent: Friday, May 03, 2013 10:33 AM
>> > To: Hayeswang
>> > Cc: oliver@neukum.org; netdev@vger.kernel.org; 
>> > linux-kernel@vger.kernel.org; linux-usb@vger.kernel.org; nic_swsd
>> > Subject: Re: [PATCH v3 net-next] net/usb: new driver for RTL8152
>> > 
>> > On Fri, May 03, 2013 at 10:01:25AM +0800, Hayes Wang wrote:
>> > > Add new driver for supporting Realtek RTL8152 Based USB 2.0 
>> > Ethernet Adapters
>> > > 
>> > > Signed-off-by: Hayes Wang <hayeswang@realtek.com>
>> > > Cc: Realtek linux nic maintainers <nic_swsd@realtek.com>
>> > 
>> > You removed the wording I had questions about last time, does 
>> > that mean
>> > the previous wording was not correct, or that you no longer are
>> > publicising the fact that this driver reads on some patents that you
>> > own?
>> > 
>> > You also failed to answer my previous questions, why?
>> 
>> That description is about the patent for the hw design, not for
>> software. It indicates that the design of the hw uses those patents
>> from the other compnay. I have no idea about how to deal with those
>> patents. What should I do for sending a patch? 
> 
> That makes sense to me, removing it is correct.  It's now up to the
> netdev developers to accept this, thanks for the quick response.

I think this clears things up and that specific issue is no longer a
blocker for inclusion.

I'll let this sit on the list so that it may be reviewed on it's
technical merits.
