Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754202AbaG2VV3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 17:21:29 -0400
Received: from ns1.pc-advies.be ([83.149.101.17]:51004 "EHLO
	spo001.leaseweb.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752073AbaG2VV1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 17:21:27 -0400
Date: Tue, 29 Jul 2014 22:54:05 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Sangjung Woo <sangjung.woo@samsung.com>, linux-watchdog@vger.kernel.org,
        linux-kernel@vger.kernel.org, again4you@gmail.com,
        Jiri Kosina <trivial@kernel.org>
Subject: Re: [PATCH] Documentation: fix a typo in watchdog-api.txt
Message-ID: <20140729205405.GA30849@spo001.leaseweb.com>
References: <1406621064-5466-1-git-send-email-sangjung.woo@samsung.com> <53D7D02D.6010508@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53D7D02D.6010508@infradead.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Randy,

> On 07/29/14 01:04, Sangjung Woo wrote:
> > Signed-off-by: Sangjung Woo <sangjung.woo@samsung.com>
> > ---
> >  Documentation/watchdog/watchdog-api.txt |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/Documentation/watchdog/watchdog-api.txt b/Documentation/watchdog/watchdog-api.txt
> > index eb7132e..53c49a4 100644
> > --- a/Documentation/watchdog/watchdog-api.txt
> > +++ b/Documentation/watchdog/watchdog-api.txt
> > @@ -118,7 +118,7 @@ resets.
> >  Note that the pretimeout is the number of seconds before the time
> >  when the timeout will go off.  It is not the number of seconds until
> >  the pretimeout.  So, for instance, if you set the timeout to 60 seconds
> > -and the pretimeout to 10 seconds, the pretimout will go of in 50
> > +and the pretimeout to 10 seconds, the pretimout will go off in 50
> 
>                                          pretimeout
> 
> Please correct that word also and then resend.  Also resend to:
> trivial@kernel.org
> 

Can take this one through the linux-watchdog tree also.

Kind regards,
Wim.

