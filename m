Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753852AbbAMGBC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 01:01:02 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:40096 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753821AbbAMGBA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 01:01:00 -0500
Date: Mon, 12 Jan 2015 21:58:17 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc: Emrys Bayliss <emrys@paradise.net.nz>, forest@alittletooquiet.net,
        tvboxspy@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] Staging: vt6656: Checkpatch fix: else after break or
 return
Message-ID: <20150113055817.GA10754@kroah.com>
References: <1421081496-15772-1-git-send-email-emrys@paradise.net.nz>
 <20150113052312.GA3497@sudip-PC>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150113052312.GA3497@sudip-PC>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 13, 2015 at 10:53:12AM +0530, Sudip Mukherjee wrote:
> On Tue, Jan 13, 2015 at 03:51:36AM +1100, Emrys Bayliss wrote:
> > This patch fixes the following checkpatch.pl error:
> > rxtx.c:588: WARNING: else is not generally useful after a break or return
> 
> was the checkpatch error solved with this change? have you checked?
> 
> and the checkpatch is giving error at line 558 and not at 588.
> 
> > 
> > Signed-off-by: Emrys Bayliss <emrys@paradise.net.nz>
> > ---
> >  drivers/staging/vt6656/rxtx.c | 2 --
> >  1 file changed, 2 deletions(-)
> > 
> > diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
> > index ea5140a..0cce140 100644
> > --- a/drivers/staging/vt6656/rxtx.c
> > +++ b/drivers/staging/vt6656/rxtx.c
> > @@ -574,8 +574,6 @@ static u16 vnt_fill_cts_head(struct vnt_usb_send_context *tx_context,
> >  
> >  		return vnt_rxtx_datahead_g(tx_context, &buf->data_head);
> >  	}
> > -
> > -	return 0;
> 
> any reason why this return was removed ?

Because it's not needed.
