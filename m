Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751129Ab3HSGzk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 02:55:40 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:21759 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751118Ab3HSGzi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 02:55:38 -0400
Date: Mon, 19 Aug 2013 09:52:00 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: rucsoftsec <rucsoftsec@gmail.com>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Iker Pedrosa <ikerpedrosam@gmail.com>,
        devel <devel@driverdev.osuosl.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Re: [PATCH] Staging: rtl8192e: rtllib_rx: checking NULL value
 afterdoing dev_alloc_skb
Message-ID: <20130819064644.GO4713@mwanda>
References: <1375959404-3276-1-git-send-email-ikerpedrosam@gmail.com>
 <20130809123813.GK5502@mwanda>
 <20130816134403.ca4ee9e841a178c1c6dd87e8@gmail.com>
 <201308190915108848173@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201308190915108848173@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 19, 2013 at 09:15:15AM +0800, rucsoftsec wrote:
> I have read that file. But the trouble is that I was not sure
> whether it is a bug or not. So I report it to BugZilla, and wait
> for further confirmation.
> Thank you all the same!
> 

If you send it to kernel-janitors we will be happy to review it.
It will be faster than bugzilla.

regards,
dan carpenter

