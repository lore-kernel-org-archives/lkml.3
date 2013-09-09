Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753885Ab3IIOww (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 10:52:52 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:25126 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752699Ab3IIOwv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 10:52:51 -0400
Date: Mon, 9 Sep 2013 17:52:29 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, Minchan Kim <minchan@kernel.org>,
        Jerome Marchand <jmarchan@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] staging: zram: minimize `slot_free_lock' usage (v2)
Message-ID: <20130909145229.GB19256@mwanda>
References: <20130906151255.GE2238@swordfish.minsk.epam.com>
 <20130909123329.GZ19256@mwanda>
 <20130909124942.GA2221@swordfish.minsk.epam.com>
 <20130909132124.GY6329@mwanda>
 <20130909144259.GB2221@swordfish.minsk.epam.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130909144259.GB2221@swordfish.minsk.epam.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 09, 2013 at 05:42:59PM +0300, Sergey Senozhatsky wrote:
> > 3) Explain why it is safe to test zram->slot_free_rq when we are not
> >    holding the lock.  I think it is unsafe.  I don't want to even think
> >    about it without the numbers.
> 
> atomic pointer test, which is either NULL or !NULL.
> 

That's not how concurency works.  Atomic types are complicated than
that.  Anyway, the zram maintainers don't need me to explain that to
them so I'll let them take over from here.

regards,
dan carpenter

