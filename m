Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755314Ab3HPLoL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 07:44:11 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:65043 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755230Ab3HPLoI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 07:44:08 -0400
Date: Fri, 16 Aug 2013 13:44:03 +0200
From: Iker Pedrosa <ikerpedrosam@gmail.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: rucsoftsec@gmail.com, gregkh@linuxfoundation.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: rtl8192e: rtllib_rx: checking NULL value after
 doing dev_alloc_skb
Message-Id: <20130816134403.ca4ee9e841a178c1c6dd87e8@gmail.com>
In-Reply-To: <20130809123813.GK5502@mwanda>
References: <1375959404-3276-1-git-send-email-ikerpedrosam@gmail.com>
	<20130809123813.GK5502@mwanda>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.17; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So, what should I do? Do I send the patch via bugzilla? I'm a newbie and I don't know that to do, what do you recommend me?

On Fri, 9 Aug 2013 15:38:13 +0300
Dan Carpenter <dan.carpenter@oracle.com> wrote:

> On Thu, Aug 08, 2013 at 12:56:44PM +0200, Iker Pedrosa wrote:
> > Checking the return of dev_alloc_skb as stated in the following
> > bug: https://bugzilla.kernel.org/show_bug.cgi?id=60401
> > 
> 
> Using bugzilla to report these sorts of bugs is a bit awkward.
> Normally we would try to give credit for bug reports but bugzilla
> hides the email if you aren't logged in.
> 
> Reported-by: RUC_Soft_Sec rucsoftsec@gmail.com
> 
> regards,
> dan carpenter
> 


-- 
Regards,

Iker Pedrosa <ikerpedrosam@gmail.com>
