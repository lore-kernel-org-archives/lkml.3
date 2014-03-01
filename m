Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752347AbaCAMIF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2014 07:08:05 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:39929 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750869AbaCAMID (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2014 07:08:03 -0500
Date: Sat, 1 Mar 2014 15:07:00 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Monam Agarwal <monamagarwal123@gmail.com>
Cc: forest@alittletooquiet.net, Greg KH <gregkh@linuxfoundation.org>,
        more.andres@gmail.com, nandu.hgowda@gmail.com,
        valentina.manea.m@gmail.com,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Staging driver: drivers/staging/vt6656/
Message-ID: <20140301120129.GF26722@mwanda>
References: <CAFB2WuVNJY0wqGwg6c0M1pgx8P1h+3=UpGHW0=bxR65LSm3Edw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFB2WuVNJY0wqGwg6c0M1pgx8P1h+3=UpGHW0=bxR65LSm3Edw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 01, 2014 at 03:37:17PM +0530, Monam Agarwal wrote:
> Hello all,
> 
> I have a confusion regarding functions in aes_ccmp.c. It seems none of
> these functions are currently being used. So Is fine if we can remove
> this file or should we keep it.

Are you sure?  The first function I looked at was used.

regards,
dan carpenter

