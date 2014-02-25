Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753309AbaBYOdq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 09:33:46 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57637 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752227AbaBYOdp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 09:33:45 -0500
Date: Tue, 25 Feb 2014 06:36:38 -0800
From: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To: Ian Abbott <abbotti@mev.co.uk>
Cc: Monam Agarwal <monamagarwal123@gmail.com>,
        Ian Abbott <ian.abbott@mev.co.uk>,
        "hsweeten@visionengravers.com" <hsweeten@visionengravers.com>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Staging: comedi: Fix line length exceeding 80 characters
Message-ID: <20140225143638.GA2497@kroah.com>
References: <1393260582-10234-1-git-send-email-monamagarwal123@gmail.com>
 <530C666B.6080900@mev.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <530C666B.6080900@mev.co.uk>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 25, 2014 at 09:46:19AM +0000, Ian Abbott wrote:
> On 2014-02-24 16:49, Monam Agarwal wrote:
> > Signed-off-by: Monam Agarwal <monamagarwal123@gmail.com>
> > ---
> >   drivers/staging/comedi/comedi_fops.c |    3 ++-
> >   1 file changed, 2 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/staging/comedi/comedi_fops.c b/drivers/staging/comedi/comedi_fops.c
> > index ac1edd9..7da8566 100644
> > --- a/drivers/staging/comedi/comedi_fops.c
> > +++ b/drivers/staging/comedi/comedi_fops.c
> > @@ -1481,7 +1481,8 @@ static int do_cmd_ioctl(struct comedi_device *dev,
> >   	async->cmd.data = NULL;
> >   	/* load channel/gain list */
> >   	async->cmd.chanlist = memdup_user(user_chanlist,
> > -					  async->cmd.chanlist_len * sizeof(int));
> > +					  async->cmd.chanlist_len
> > +					  * sizeof(int));
> 
> The `*` operator should go at the end of the line according to the 
> CodingStyle.

Which is why I modified it by hand before applying it :)
