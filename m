Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750770Ab3HSDVY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Aug 2013 23:21:24 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46326 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750708Ab3HSDVX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Aug 2013 23:21:23 -0400
Date: Sun, 18 Aug 2013 20:23:09 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: rucsoftsec <rucsoftsec@gmail.com>
Cc: Iker Pedrosa <ikerpedrosam@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        devel <devel@driverdev.osuosl.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Re: [PATCH] Staging: rtl8192e: rtllib_rx: checking NULL value
 afterdoing dev_alloc_skb
Message-ID: <20130819032309.GA21419@kroah.com>
References: <1375959404-3276-1-git-send-email-ikerpedrosam@gmail.com>
 <20130809123813.GK5502@mwanda>
 <20130816134403.ca4ee9e841a178c1c6dd87e8@gmail.com>
 <201308190915108848173@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201308190915108848173@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 19, 2013 at 09:15:15AM +0800, rucsoftsec wrote:
> I have read that file. But the trouble is that I was not sure whether it is a
> bug or not. So I report it to BugZilla, and wait for further confirmation.

Don't worry about bugzilla, please send us a patch through email so we
can accept it.  We can't take anything from bugzilla.

thanks,

greg k-h
