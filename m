Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751663AbaKYUlN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 15:41:13 -0500
Received: from mail-wi0-f170.google.com ([209.85.212.170]:40468 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751045AbaKYUlM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 15:41:12 -0500
Date: Tue, 25 Nov 2014 20:40:56 +0000
From: Luis de Bethencourt <luis@debethencourt.com>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, jarod@wilsonet.com, m.chehab@samsung.com,
        gregkh@linuxfoundation.org, mahfouz.saif.elyazal@gmail.com,
        dan.carpenter@oracle.com, tuomas.tynkkynen@iki.fi,
        gulsah.1004@gmail.com, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org
Subject: Re: [PATCH] staging: media: lirc: lirc_zilog.c: fix quoted strings
 split across lines
Message-ID: <20141125204056.GA12162@biggie>
References: <20141125201905.GA10900@biggie>
 <1416947244.8358.12.camel@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1416947244.8358.12.camel@perches.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 25, 2014 at 12:27:24PM -0800, Joe Perches wrote:
> On Tue, 2014-11-25 at 20:19 +0000, Luis de Bethencourt wrote:
> > checkpatch makes an exception to the 80-colum rule for quotes strings, and
> > Documentation/CodingStyle recommends not splitting quotes strings across lines
> > because it breaks the ability to grep for the string. Fixing these.
> []
> > diff --git a/drivers/staging/media/lirc/lirc_zilog.c b/drivers/staging/media/lirc/lirc_zilog.c
> []
> > @@ -794,8 +792,7 @@ static int fw_load(struct IR_tx *tx)
> >  	if (!read_uint8(&data, tx_data->endp, &version))
> >  		goto corrupt;
> >  	if (version != 1) {
> > -		dev_err(tx->ir->l.dev, "unsupported code set file version (%u, expected"
> > -			    "1) -- please upgrade to a newer driver",
> > +		dev_err(tx->ir->l.dev, "unsupported code set file version (%u, expected1) -- please upgrade to a newer driver",
> >  			    version);
> 
> Hello Luis.
> 
> Please look at the strings being coalesced before
> submitting patches.
> 
> It's a fairly common defect to have either a missing
> space between the coalesced fragments or too many
> spaces.
> 
> It's almost certain that there should be a space
> between the "expected" and "1" here.
> 
> 

Hello Joe,

Thanks for taking the time to review this. I sent a new
version fixing the missing space. 
