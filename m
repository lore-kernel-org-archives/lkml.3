Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752573AbaHMJXG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 05:23:06 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:24788 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751145AbaHMJXC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 05:23:02 -0400
Date: Wed, 13 Aug 2014 12:22:47 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: DaeSeok Youn <daeseok.youn@gmail.com>
Cc: Lidza Louina <lidza.louina@gmail.com>, Mark Hounschell <markh@compro.net>,
        devel <devel@driverdev.osuosl.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        driverdev-devel@linuxdriverproject.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/7] staging: dgap: remove useless variable
Message-ID: <20140813092246.GT11899@mwanda>
References: <20140809053644.GA14630@devel.8.8.4.4>
 <20140811105640.GN4856@mwanda>
 <CAHb8M2Dz5iWFcW8WNZkA_ikD0uKJqTuLQtkw4h6+7QCJ-3dL1A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHb8M2Dz5iWFcW8WNZkA_ikD0uKJqTuLQtkw4h6+7QCJ-3dL1A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 12, 2014 at 09:28:13AM +0900, DaeSeok Youn wrote:
> Hi, Dan
> 
> 2014-08-11 19:56 GMT+09:00 Dan Carpenter <dan.carpenter@oracle.com>:
> > On Sat, Aug 09, 2014 at 02:36:44PM +0900, Daeseok Youn wrote:
> >> dgap_major_serial_registered and dgap_major_transparent_print_registered
> >> could be checked whether a board is initialized.
> >> But it doesn't need to check that variables becasue dgap module
> >> isn't calling the dgap_cleanup_tty() without initializing
> >> for a board completely.
> >
> > I don't understand.  What about the call to dgap_cleanup_module() in
> > dgap_init_module()?
> I think the call of dgap_cleanup_tty()
> in dgap_cleanup_module() from dgap_init_module() is not reached.
> Because dgap_init_module() is called when driver is loaded, at this
> point of time,
> there are no boards that are initialized.(dgap_numboards is zero)
> 
> And the change log of this is needed to modify for clearing message.

Ah.  Ok.  Thanks for the explanation.

Reviewed-by: Dan Carpenter <dan.carpenter@oracle.com>

regards,
dan carpenter
