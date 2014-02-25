Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752619AbaBYLGA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 06:06:00 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:43091 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750993AbaBYLF7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 06:05:59 -0500
Date: Tue, 25 Feb 2014 14:05:32 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Joe Perches <joe@perches.com>
Cc: Ian Abbott <abbotti@mev.co.uk>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        Ian Abbott <ian.abbott@mev.co.uk>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Monam Agarwal <monamagarwal123@gmail.com>
Subject: Re: [PATCH] Staging: comedi: Fix line length exceeding 80 characters
Message-ID: <20140225110532.GK26722@mwanda>
References: <1393260582-10234-1-git-send-email-monamagarwal123@gmail.com>
 <530C666B.6080900@mev.co.uk>
 <1393322365.8716.3.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1393322365.8716.3.camel@joe-AO722>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 25, 2014 at 01:59:25AM -0800, Joe Perches wrote:
> On Tue, 2014-02-25 at 09:46 +0000, Ian Abbott wrote:
> > On 2014-02-24 16:49, Monam Agarwal wrote:
> []
> > > diff --git a/drivers/staging/comedi/comedi_fops.c b/drivers/staging/comedi/comedi_fops.c
> []
> > > @@ -1481,7 +1481,8 @@ static int do_cmd_ioctl(struct comedi_device *dev,
> > >   	async->cmd.data = NULL;
> > >   	/* load channel/gain list */
> > >   	async->cmd.chanlist = memdup_user(user_chanlist,
> > > -					  async->cmd.chanlist_len * sizeof(int));
> > > +					  async->cmd.chanlist_len
> > > +					  * sizeof(int));
> > 
> > The `*` operator should go at the end of the line according to the 
> > CodingStyle.
> 
> I don't believe there's a CodingStyle guide for this.
> 

Meanwhile you have felt totally justified in correcting me on this in
the past.  :P

Anyway, it should be that the operator goes on the first line like Ian
says...

regards,
dan carpenter

