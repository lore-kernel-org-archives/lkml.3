Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752709AbaJIKYB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 06:24:01 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:28306 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751219AbaJIKXy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 06:23:54 -0400
Date: Thu, 9 Oct 2014 13:23:41 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc: Daeseok Youn <daeseok.youn@gmail.com>, devel@driverdev.osuosl.org,
        lidza.louina@gmail.com, driverdev-devel@linuxdriverproject.org,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org
Subject: Re: [PATCH V2] staging: dgap: introduce dgap_stop()
Message-ID: <20141009102341.GU23154@mwanda>
References: <20141009044011.GA999@devel>
 <20141009094902.GA4333@sudip-PC>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141009094902.GA4333@sudip-PC>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 09, 2014 at 03:19:03PM +0530, Sudip Mukherjee wrote:
> On Thu, Oct 09, 2014 at 01:40:11PM +0900, Daeseok Youn wrote:
> > The dgap_init_module() need to unwind for cleanup variables properly.
> > Because dgap_init_module() calls dgap_cleanup_module() for freeing
> > variables but this function is possible to free variables
> > which are not allocated.
> > 
> > Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
> > ---
> > V2: change ulong which is non-standard to "unsigned long".
> I think , Dan, in his review of your v1 , asked you to rearrange the functions and get rid of the forward declarations.
> 

I was fine with v1 actually...  It's a bug fix, and this is staging and
there are tons of forward declarations already.  Eventually we need to
get rid of them but it can be done later.

regards,
dan carpenter

