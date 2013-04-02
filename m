Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761719Ab3DBQbn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 12:31:43 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:60228 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756980Ab3DBQbm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 12:31:42 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18av9TRJeIZb83dTrsxDhHk
Date: Tue, 2 Apr 2013 09:31:38 -0700
From: Tony Lindgren <tony@atomide.com>
To: Pali =?utf-8?B?Um9ow6Fy?= <pali.rohar@gmail.com>
Cc: Sebastian Reichel <sre@debian.org>, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Joni Lapilainen <joni.lapilainen@gmail.com>,
        Aaro Koskinen <aaro.koskinen@iki.fi>
Subject: Re: [PATCH] RX-51: Fix probe order of SPI devices
Message-ID: <20130402163138.GS10155@atomide.com>
References: <1364724561-18045-1-git-send-email-pali.rohar@gmail.com>
 <20130331105222.GA22426@earth.universe>
 <201303311318.41846@pali>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201303311318.41846@pali>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Pali Rohár <pali.rohar@gmail.com> [130331 04:23]:
> On Sunday 31 March 2013 12:52:23 Sebastian Reichel wrote:
> > On Sun, Mar 31, 2013 at 12:09:21PM +0200, Pali Rohár wrote:
> > > From: Joni Lapilainen <joni.lapilainen@gmail.com>
> > > 
> > > Without this patch LCD panel on Nokia RX-51 is still black
> > > 
> > > Signed-off-by: Joni Lapilainen <joni.lapilainen@gmail.com>
> > > Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
> > 
> > Tested-by: Sebastian Reichel <sre@debian.org>
> > 
> > Please note, that this patch has actually been proposed by
> > Aaro Koskinen <aaro.koskinen@iki.fi> quite some time ago [0].
> > 
> > [0]
> > http://permalink.gmane.org/gmane.linux.ports.arm.omap/81729
> > 
> > -- Sebastian
> 
> CCing Aaro.

Any ideas why this is happening?

Is the touch screen controller somehow pulling one of the SPI
lines before it's reset? I don't think there's any other connection
between the LCD and touch controller besides the SPI lines?

In any case there should be something in the description why
this is needed..

Regards,

Tony
