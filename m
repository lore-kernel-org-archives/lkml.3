Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935959Ab3DIGWm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 02:22:42 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:35071 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935239Ab3DIGWl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 02:22:41 -0400
Date: Tue, 9 Apr 2013 09:22:24 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Alexey Khoroshilov <khoroshilov@ispras.ru>
Cc: Jiri Slaby <jirislaby@gmail.com>, kbuild@01.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch] tty: mxser: forever loops on error
Message-ID: <20130409062224.GB9245@mwanda>
References: <20130409051838.GB1516@longonot.mountain>
 <5163AC2B.7060804@ispras.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5163AC2B.7060804@ispras.ru>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 09, 2013 at 09:50:35AM +0400, Alexey Khoroshilov wrote:
> Hi Dan,
> 
> Thank you for the patch.
> 
> We are also trying to fix the issue:
> https://lkml.org/lkml/2013/2/19/29
> https://lkml.org/lkml/2013/4/8/55
> 
> and the fix is finally in Greg's tty git tree since yesterday:
>     git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty.git
> (tty-linus branch).
> 

Good deal.

Btw, by the time that Fenguang's kbuild scripts emailed you, it was
already too late to send a v2 patch.

regards,
dan carpenter
