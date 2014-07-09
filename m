Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932315AbaGHTOe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 15:14:34 -0400
Received: from mailrelay012.isp.belgacom.be ([195.238.6.179]:14824 "EHLO
	mailrelay012.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932127AbaGHTNi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 15:13:38 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgRoANpBvFNXQDwH/2dsb2JhbABZH4JvUoJ4qVsBAQEBAQEFAW4BkhKHQwICAYEXF3WEAwEBBAE6PwULCAMOCh0ROR4GE4g6DAHIFBeFeohkZAeEQwEEhGkDlgkBgUiSRINFO4Ex
Date: Wed, 9 Jul 2014 04:12:15 +0200
From: Fabian Frederick <fabf@skynet.be>
To: Antti Palosaari <crope@iki.fi>
Cc: linux-kernel@vger.kernel.org, Mauro Carvalho Chehab <m.chehab@samsung.com>,
        linux-media@vger.kernel.org
Subject: Re: [PATCH 1/1] dvb-frontends: remove unnecessary break after goto
Message-Id: <20140709041215.3e1083201f5a400c37b820b0@skynet.be>
In-Reply-To: <53BC3A0E.4060505@iki.fi>
References: <1404840181-29822-1-git-send-email-fabf@skynet.be>
	<53BC3A0E.4060505@iki.fi>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 08 Jul 2014 21:35:58 +0300
Antti Palosaari <crope@iki.fi> wrote:

> Moikka Fabian!
> I have no reason to decline that patch (I will apply it) even it has 
> hardly meaning. But is there now some new tool which warns that kind of 
> issues?
Hello Antti,

	Thanks :) AFAIK there's still no automatic detection of those cases.

Regards,
Fabian
> 
> regards
> Atnti
> 
> 
> On 07/08/2014 08:23 PM, Fabian Frederick wrote:
> > Cc: Antti Palosaari <crope@iki.fi>
> > Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>
> > Cc: linux-media@vger.kernel.org
> > Signed-off-by: Fabian Frederick <fabf@skynet.be>
> > ---
> >   drivers/media/dvb-frontends/af9013.c | 1 -
> >   1 file changed, 1 deletion(-)
> >
> > diff --git a/drivers/media/dvb-frontends/af9013.c b/drivers/media/dvb-frontends/af9013.c
> > index fb504f1..ecf6388 100644
> > --- a/drivers/media/dvb-frontends/af9013.c
> > +++ b/drivers/media/dvb-frontends/af9013.c
> > @@ -470,7 +470,6 @@ static int af9013_statistics_snr_result(struct dvb_frontend *fe)
> >   		break;
> >   	default:
> >   		goto err;
> > -		break;
> >   	}
> >
> >   	for (i = 0; i < len; i++) {
> >
> 
> -- 
> http://palosaari.fi/
