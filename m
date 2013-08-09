Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757917Ab3HIMig (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 08:38:36 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:22781 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756209Ab3HIMif (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 08:38:35 -0400
Date: Fri, 9 Aug 2013 15:38:13 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Iker Pedrosa <ikerpedrosam@gmail.com>, rucsoftsec@gmail.com
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: rtl8192e: rtllib_rx: checking NULL value after
 doing dev_alloc_skb
Message-ID: <20130809123813.GK5502@mwanda>
References: <1375959404-3276-1-git-send-email-ikerpedrosam@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375959404-3276-1-git-send-email-ikerpedrosam@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 08, 2013 at 12:56:44PM +0200, Iker Pedrosa wrote:
> Checking the return of dev_alloc_skb as stated in the following
> bug: https://bugzilla.kernel.org/show_bug.cgi?id=60401
> 

Using bugzilla to report these sorts of bugs is a bit awkward.
Normally we would try to give credit for bug reports but bugzilla
hides the email if you aren't logged in.

Reported-by: RUC_Soft_Sec rucsoftsec@gmail.com

regards,
dan carpenter

