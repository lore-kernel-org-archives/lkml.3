Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756260AbaEIKwG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 06:52:06 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:16658 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751499AbaEIKwF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 06:52:05 -0400
Date: Fri, 9 May 2014 13:51:49 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Daeseok Youn <daeseok.youn@gmail.com>
Cc: gregkh@linuxfoundation.org, himangi774@gmail.com, sachin.kamat@linaro.org,
        fempsci@gmail.com, nandu.hgowda@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/5] staging: cxt1e1: remove dead code in musycc.c
Message-ID: <20140509105149.GH4963@mwanda>
References: <20140509100606.GA6479@devel.8.8.4.4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140509100606.GA6479@devel.8.8.4.4>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 09, 2014 at 07:06:06PM +0900, Daeseok Youn wrote:
> Removes "#if 0" blocks.
> 
> Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
> ---
> Dan,
>  I decided to leave musycc_dump_rxbuffer_ring(ch, 0) which is commented
>  out and make a block as "RLD_DEBUG". Because i think this block need to debug
>  with define "RLD_DEBUG". If I am wrong, let me know.
> 

This change should maybe have been in a separate patch.  It's a border
line thing.  But definitely, it should have been mentioned in the
changelog.

Btw, you can use `git citool` to add or remove lines from a
commit.  Highlight and right click on the lines you want to add or
remove.

I don't really care either way if you keep it or delete it.

regards,
dan carpenter

