Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965183Ab3DJRAQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 13:00:16 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:23135 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965054Ab3DJRAK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 13:00:10 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+3woJs0643Skj0zTGEaPi6
Date: Wed, 10 Apr 2013 10:00:05 -0700
From: Tony Lindgren <tony@atomide.com>
To: Pali =?utf-8?B?Um9ow6Fy?= <pali.rohar@gmail.com>
Cc: Sebastian Reichel <sre@debian.org>, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Joni Lapilainen <joni.lapilainen@gmail.com>,
        Aaro Koskinen <aaro.koskinen@iki.fi>
Subject: Re: [PATCH] RX-51: Fix probe order of SPI devices
Message-ID: <20130410170001.GY10155@atomide.com>
References: <1364724561-18045-1-git-send-email-pali.rohar@gmail.com>
 <201303311318.41846@pali>
 <20130402163138.GS10155@atomide.com>
 <201304101615.19400@pali>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201304101615.19400@pali>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Pali Rohár <pali.rohar@gmail.com> [130410 07:20]:
> On Tuesday 02 April 2013 18:31:38 Tony Lindgren wrote:
> > * Pali Rohár <pali.rohar@gmail.com> [130331 04:23]:
> > > On Sunday 31 March 2013 12:52:23 Sebastian Reichel wrote:
> > > > On Sun, Mar 31, 2013 at 12:09:21PM +0200, Pali Rohár wrote:
> > > > > From: Joni Lapilainen <joni.lapilainen@gmail.com>
> > > > > 
> > > > > Without this patch LCD panel on Nokia RX-51 is still
> > > > > black
> > > > > 
> > > > > Signed-off-by: Joni Lapilainen
> > > > > <joni.lapilainen@gmail.com> Signed-off-by: Pali Rohár
> > > > > <pali.rohar@gmail.com>
> > > > 
> > > > Tested-by: Sebastian Reichel <sre@debian.org>
> > > > 
> > > > Please note, that this patch has actually been proposed by
> > > > Aaro Koskinen <aaro.koskinen@iki.fi> quite some time ago
> > > > [0].
> > > > 
> > > > [0]
> > > > http://permalink.gmane.org/gmane.linux.ports.arm.omap/8172
> > > > 9
> > > > 
> > > > -- Sebastian
> > > 
> > > CCing Aaro.
> > 
> > Any ideas why this is happening?
> > 
> > Is the touch screen controller somehow pulling one of the SPI
> > lines before it's reset? I don't think there's any other
> > connection between the LCD and touch controller besides the
> > SPI lines?
> > 
> > In any case there should be something in the description why
> > this is needed..
> > 
> > Regards,
> > 
> > Tony
> 
> Hi Tony, look at this Aaro's email:
> http://permalink.gmane.org/gmane.linux.ports.arm.omap/81729

OK can we have that summarized in the patch description please?

Regards,

Tony
