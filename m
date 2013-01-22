Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754049Ab3AVIFd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 03:05:33 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:45948 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752160Ab3AVIFc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 03:05:32 -0500
Date: Tue, 22 Jan 2013 11:05:26 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: devel@driverdev.osuosl.org, linux-iio@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, Jonathan Cameron <jic23@cam.ac.uk>
Subject: Re: [PATCH] staging/iio: Use correct argument for sizeof
Message-ID: <20130122080525.GX4584@mwanda>
References: <1358802842-27614-1-git-send-email-peterhuewe@gmx.de>
 <20130122064351.GV4584@mwanda>
 <50FE477D.7060401@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50FE477D.7060401@metafoo.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 22, 2013 at 09:02:05AM +0100, Lars-Peter Clausen wrote:
> On 01/22/2013 07:43 AM, Dan Carpenter wrote:
> > On Mon, Jan 21, 2013 at 10:14:02PM +0100, Peter Huewe wrote:
> >> found with coccicheck
> >> sizeof when applied to a pointer typed expression gives the size of
> >> the pointer
> >>
> > 
> > The original code is correct, in this case.  We're storing an array
> > of pointers and the last element in the array is a NULL.
> > 
> 
> The patch changed sizeof(st->attrs) to sizeof(*st->attrs). The type of
> st->attrs is struct attribute **, so both sizeofs return the same value (the
> size of an pointer) and the code happens to work, still the later is
> semantically more correct.
> 

Yeah.  You're right, my bad.  The patch is fine.

regards,
dan carpenter

