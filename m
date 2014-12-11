Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758519AbaLKAUw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 19:20:52 -0500
Received: from mail-wg0-f44.google.com ([74.125.82.44]:44231 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758463AbaLKAUu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 19:20:50 -0500
Date: Thu, 11 Dec 2014 00:20:14 +0000
From: Luis de Bethencourt <luis@debethencourt.com>
To: Joe Perches <joe@perches.com>
Cc: m.chehab@samsung.com, jarod@wilsonet.com, gregkh@linuxfoundation.org,
        mahfouz.saif.elyazal@gmail.com, gulsah.1004@gmail.com,
        tuomas.tynkkynen@iki.fi, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 1/2] staging: media: lirc: lirc_zilog.c: fix quoted
 strings split across lines
Message-ID: <20141211002014.GA10894@biggie>
References: <20141210223339.GA9397@biggie>
 <1418254749.18092.24.camel@perches.com>
 <20141210235741.GA10195@biggie>
 <1418256064.18092.26.camel@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1418256064.18092.26.camel@perches.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 10, 2014 at 04:01:04PM -0800, Joe Perches wrote:
> On Wed, 2014-12-10 at 23:57 +0000, Luis de Bethencourt wrote:
> > On Wed, Dec 10, 2014 at 03:39:09PM -0800, Joe Perches wrote:
> > > On Wed, 2014-12-10 at 22:33 +0000, Luis de Bethencourt wrote:
> > > > diff --git a/drivers/staging/media/lirc/lirc_zilog.c b/drivers/staging/media/lirc/lirc_zilog.c
> []
> > > > +		dev_err(tx->ir->l.dev,
> > > > +			"unsupported code set file version (%u, expected 1) -- please upgrade to a newer driver",
> > > > +			version);
> > > 
> > > Unrelated but this one should have a '\n' termination
> > > at the end of the format.
> > I can add that change, no problem. As part of this patch or a third one?
> 
> Up to you.
> 
> 

I like keeping my patches divided in functional units. Resubmitting these
patches as v5 with your suggestion as the third one, since it needs to be
applied on top of the other 2.

Thanks Joe!

Luis
