Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754278AbaA0XDB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 18:03:01 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:19152 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753413AbaA0XC7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 18:02:59 -0500
Date: Tue, 28 Jan 2014 02:02:12 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: xypron.glpk@gmx.de, devel@driverdev.osuosl.org, ke42caxa@cip.cs.fau.de,
        linux-usb@vger.kernel.org, ly80toro@cip.cs.fau.de,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] usbip/userspace/libsrc/names.c: memory leak
Message-ID: <20140127230212.GA5364@mwanda>
References: <1390861789-8981-1-git-send-email-xypron.glpk@gmx.de>
 <20140127225004.GA17970@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140127225004.GA17970@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 27, 2014 at 02:50:04PM -0800, Greg KH wrote:
> On Mon, Jan 27, 2014 at 11:29:48PM +0100, xypron.glpk@gmx.de wrote:
> > From: Heinrich Schuchardt <xypron.glpk@gmx.de>
> > 
> > p is freed if NULL.
> 
> Not a real problem, right?
> 
> > p is leaked if second calloc fails.
> 
> You just created a new bug in your "fix" :(
> 
> Please run your patches through scripts/checkpatch.pl, odds are, it
> would have caught this error.
> 

Checkpatch doesn't catch the problems here.  I thought it would have
caught the style issue but apparently it only looks for extra curly
braces when you run it in --file mode.

Fengguang would hopefully have caught the missing curly braces bug with
Coccinelle.

regards,
dan carpenter
