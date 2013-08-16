Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756011Ab3HPM07 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 08:26:59 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:50644 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754318Ab3HPM05 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 08:26:57 -0400
Date: Fri, 16 Aug 2013 05:28:33 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Iker Pedrosa <ikerpedrosam@gmail.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>, rucsoftsec@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: rtl8192e: rtllib_rx: checking NULL value after
 doing dev_alloc_skb
Message-ID: <20130816122833.GB24550@kroah.com>
References: <1375959404-3276-1-git-send-email-ikerpedrosam@gmail.com>
 <20130809123813.GK5502@mwanda>
 <20130816134403.ca4ee9e841a178c1c6dd87e8@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130816134403.ca4ee9e841a178c1c6dd87e8@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 16, 2013 at 01:44:03PM +0200, Iker Pedrosa wrote:
> So, what should I do? Do I send the patch via bugzilla? I'm a newbie
> and I don't know that to do, what do you recommend me?

Take a look at the kernel file, Documentation/SubmittingPatches for how
to properly send a kernel patch that we can apply.  If you have
questions after reading that, please let us know.

thanks,

greg k-h
