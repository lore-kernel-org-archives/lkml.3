Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753467Ab3H0RfR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 13:35:17 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:43335 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752150Ab3H0RfP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 13:35:15 -0400
X-Sasl-enc: C+VDiVXNqTgXmkt3wPbQZZAtR8eDpdzj+jSf2jkm1Qch 1377624914
Date: Tue, 27 Aug 2013 10:37:32 -0700
From: Greg KH <greg@kroah.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Benoit Cousson <bcousson@baylibre.com>,
        Javier Martinez Canillas <javier@dowhile0.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>, Arnd Bergmann <arnd@arndb.de>,
        linux-kernel@vger.kernel.org, Felipe Balbi <balbi@ti.com>,
        linux-next@vger.kernel.org, Olof Johansson <olof@lixom.net>,
        linux-arm-kernel@lists.infradead.org,
        "khilman@linaro.org" <khilman@linaro.org>
Subject: Re: linux-next: manual merge of the arm-soc tree with the usb tree
Message-ID: <20130827173732.GC21564@kroah.com>
References: <20130827181353.319c150858829df1bb68d60b@canb.auug.org.au>
 <521C6961.9020103@linutronix.de>
 <CABxcv=mg6t5wPqpF3j5sr_76qfZ7N7KgpWhcKSGoPTOcaR=V6A@mail.gmail.com>
 <521CA888.1080909@baylibre.com>
 <521CAF59.1090203@linutronix.de>
 <521CB046.9070408@baylibre.com>
 <521CB18B.4080000@linutronix.de>
 <521CB239.6050409@baylibre.com>
 <521CB403.8010307@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <521CB403.8010307@linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 27, 2013 at 04:13:23PM +0200, Sebastian Andrzej Siewior wrote:
> On 08/27/2013 04:05 PM, Benoit Cousson wrote:
> > On 27/08/2013 16:02, Sebastian Andrzej Siewior wrote:
> >> On 08/27/2013 03:57 PM, Benoit Cousson wrote:
> >>> + Kevin,
> >>>
> >>> On 27/08/2013 15:53, Sebastian Andrzej Siewior wrote:
> >>>> What do we do now?
> >>>
> >>> Cannot you just merge the stable arm-soc/dt branch into your branch
> >>> before applying your patches?
> >>
> >> That is up to Greg. This changes sat in his usb-next tree for a while
> >> now. And before they hit Greg they were in Felipe's tree for a while.
> >>
> >> To be exact, last .dts change via USB was:
> >>
> >> Author:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> >> AuthorDate: Thu Jun 20 12:13:04 2013 +0200
> >> Commit:     Felipe Balbi <balbi@ti.com>
> >> CommitDate: Fri Aug 9 17:40:16 2013 +0300
> >>
> >>     usb: musb dma: add cppi41 dma driver
> > 
> > Mmm, if that branch is supposed to be stable, I'm not sure it will be
> > doable...
> > 
> > Maybe we should do the other way around? And merge usb-next into
> > arm-soc/dt.
> > 
> > Kevin, Olof?
> 
> Please be aware that I have no response so far regarding [0] from Greg.
> 
> [0] http://www.spinics.net/lists/linux-usb/msg92595.html

Nor will you, given that I am not the one to take these patches, Felipe
is.  I noticed now that you said "please route around Felipe", but
sorry, no, I'm not going to do that unless there's a really good reason.
Felipe seems to be around at the moment, please work with him on this.

sorry,

greg k-h
