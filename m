Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758567AbaLJX6T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 18:58:19 -0500
Received: from mail-wi0-f176.google.com ([209.85.212.176]:45286 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758196AbaLJX6R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 18:58:17 -0500
Date: Wed, 10 Dec 2014 23:57:41 +0000
From: Luis de Bethencourt <luis@debethencourt.com>
To: Joe Perches <joe@perches.com>
Cc: m.chehab@samsung.com, jarod@wilsonet.com, gregkh@linuxfoundation.org,
        mahfouz.saif.elyazal@gmail.com, gulsah.1004@gmail.com,
        tuomas.tynkkynen@iki.fi, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 1/2] staging: media: lirc: lirc_zilog.c: fix quoted
 strings split across lines
Message-ID: <20141210235741.GA10195@biggie>
References: <20141210223339.GA9397@biggie>
 <1418254749.18092.24.camel@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1418254749.18092.24.camel@perches.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 10, 2014 at 03:39:09PM -0800, Joe Perches wrote:
> On Wed, 2014-12-10 at 22:33 +0000, Luis de Bethencourt wrote:
> > checkpatch makes an exception to the 80-colum rule for quotes strings, and
> > Documentation/CodingStyle recommends not splitting quotes strings across lines
> > because it breaks the ability to grep for the string. Fixing these.
> []
> > diff --git a/drivers/staging/media/lirc/lirc_zilog.c b/drivers/staging/media/lirc/lirc_zilog.c
> []
> > @@ -794,9 +796,9 @@ static int fw_load(struct IR_tx *tx)
> >  	if (!read_uint8(&data, tx_data->endp, &version))
> >  		goto corrupt;
> >  	if (version != 1) {
> > -		dev_err(tx->ir->l.dev, "unsupported code set file version (%u, expected"
> > -			    "1) -- please upgrade to a newer driver",
> > -			    version);
> > +		dev_err(tx->ir->l.dev,
> > +			"unsupported code set file version (%u, expected 1) -- please upgrade to a newer driver",
> > +			version);
> 
> Unrelated but this one should have a '\n' termination
> at the end of the format.
> 

I can add that change, no problem. As part of this patch or a third one?

Thanks for reviewing,
Luis
