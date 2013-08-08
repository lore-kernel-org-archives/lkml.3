Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966537Ab3HHUpK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 16:45:10 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:47869 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966438Ab3HHUpJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 16:45:09 -0400
Date: Thu, 8 Aug 2013 23:44:55 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Paul McQuade <paulmcquad@gmail.com>
Cc: gregkh@linuxfoundation.org, Linux-Devel <devel@driverdev.osuosl.org>,
        Linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] Staging: BCM: Removed more whitespace/Errors
Message-ID: <20130808204455.GC5502@mwanda>
References: <5203CF75.802@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5203CF75.802@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 08, 2013 at 06:03:49PM +0100, Paul McQuade wrote:
> -int InterfaceFileDownload( PVOID psIntfAdapter,
> -                        struct file *flp,
> -                        unsigned int on_chip_loc);
> +int InterfaceFileDownload(PVOID psIntfAdapter,
> +						struct file *flp,
> +						unsigned int on_chip_loc);


The very first line in this patch is totally wrong...  :(

This is an automated patch.  I'm not going to review any further.
Automated patches create a problem for reviews because they are
far harder to review than they are to generate.  I'm not sure what
the solution is...

Anyway, the patch is very wrong.

regards,
dan carpenter
