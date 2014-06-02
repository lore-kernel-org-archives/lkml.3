Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752865AbaFBHat (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 03:30:49 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:37099 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751796AbaFBHas (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 03:30:48 -0400
Date: Mon, 2 Jun 2014 10:30:37 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Daeseok Youn <daeseok.youn@gmail.com>
Cc: lidza.louina@gmail.com, gregkh@linuxfoundation.org,
        devel@driverdev.osuosl.org, driverdev-devel@linuxdriverproject.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6 RESEND] staging: dgap: remove useless dgap_probe1()
 function
Message-ID: <20140602073037.GR15585@mwanda>
References: <20140602050358.GA29799@devel.8.8.4.4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140602050358.GA29799@devel.8.8.4.4>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 02, 2014 at 02:03:58PM +0900, Daeseok Youn wrote:
> The dgap_probe1() function is just calling dgap_found_board().
> So it is removed and dgap_found_board() is called directly.
> 
> Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
> ---
> RESEND : this patch is included into newly serise of patches
> so renumbered and resend.

Don't do this.  Just assume that patch will be applied.  Greg applies
patches in first come, first serve order.  If it doesn't apply then he
sends an email to redo it.

Now these two first patch won't apply and he has to figure out why and
it just messes up the process.

Also don't try to fix this now by resending again without the first two
patches.  That just creates more confusion.

regards,
dan carpenter

