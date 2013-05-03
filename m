Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762508Ab3ECD6m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 23:58:42 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:36861 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762439Ab3ECD6k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 23:58:40 -0400
Date: Thu, 2 May 2013 20:23:15 -0700
From: "'Greg KH'" <gregkh@linuxfoundation.org>
To: hayeswang <hayeswang@realtek.com>
Cc: oliver@neukum.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, "'nic_swsd'" <nic_swsd@realtek.com>
Subject: Re: [PATCH v3 net-next] net/usb: new driver for RTL8152
Message-ID: <20130503032315.GA22077@kroah.com>
References: <1366965948-1805-1-git-send-email-hayeswang@realtek.com>
 <1367546485-1619-1-git-send-email-hayeswang@realtek.com>
 <20130503023328.GB26712@kroah.com>
 <4215C45C849149B8A86B57F8D603AAEA@realtek.com.tw>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4215C45C849149B8A86B57F8D603AAEA@realtek.com.tw>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 03, 2013 at 11:11:47AM +0800, hayeswang wrote:
> Greg KH [mailto:gregkh@linuxfoundation.org] 
> > Sent: Friday, May 03, 2013 10:33 AM
> > To: Hayeswang
> > Cc: oliver@neukum.org; netdev@vger.kernel.org; 
> > linux-kernel@vger.kernel.org; linux-usb@vger.kernel.org; nic_swsd
> > Subject: Re: [PATCH v3 net-next] net/usb: new driver for RTL8152
> > 
> > On Fri, May 03, 2013 at 10:01:25AM +0800, Hayes Wang wrote:
> > > Add new driver for supporting Realtek RTL8152 Based USB 2.0 
> > Ethernet Adapters
> > > 
> > > Signed-off-by: Hayes Wang <hayeswang@realtek.com>
> > > Cc: Realtek linux nic maintainers <nic_swsd@realtek.com>
> > 
> > You removed the wording I had questions about last time, does 
> > that mean
> > the previous wording was not correct, or that you no longer are
> > publicising the fact that this driver reads on some patents that you
> > own?
> > 
> > You also failed to answer my previous questions, why?
> 
> That description is about the patent for the hw design, not for
> software. It indicates that the design of the hw uses those patents
> from the other compnay. I have no idea about how to deal with those
> patents. What should I do for sending a patch? 

That makes sense to me, removing it is correct.  It's now up to the
netdev developers to accept this, thanks for the quick response.

greg k-h
