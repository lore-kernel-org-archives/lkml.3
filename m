Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752464AbaDVX64 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 19:58:56 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:50757 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750940AbaDVX6y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 19:58:54 -0400
Date: Tue, 22 Apr 2014 17:01:45 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Jonathan Cameron <jic23@kernel.org>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        linux-iio@vger.kernel.org,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Josh Wu <josh.wu@atmel.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] ARM: at91: at91sam9g45: change at91_adc name
Message-ID: <20140423000145.GA31342@kroah.com>
References: <1394038675-15809-1-git-send-email-alexandre.belloni@free-electrons.com>
 <1394038675-15809-3-git-send-email-alexandre.belloni@free-electrons.com>
 <5318C98C.1070702@kernel.org>
 <531DBD71.8040905@atmel.com>
 <532472B8.4090802@kernel.org>
 <5356E406.40507@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5356E406.40507@atmel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22, 2014 at 11:49:58PM +0200, Nicolas Ferre wrote:
> On 15/03/2014 16:33, Jonathan Cameron :
> > On 10/03/14 13:26, Nicolas Ferre wrote:
> >> On 06/03/2014 20:16, Jonathan Cameron :
> >>> On 05/03/14 16:57, Alexandre Belloni wrote:
> >>>> We can't use "at91_adc" to refer to the at91_adc driver anymore as the name is
> >>>> used to match an id_table.
> >>>>
> >>>> Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
> >>> As stated in previous email, I'll take this along with the fix that 'broke'
> >>> this, if I get an Ack from one of the at91 maintainers.
> >>
> >> Jonathan,
> >>
> >> It is maybe more clear if I answer here:
> >> - so, yes, you can take the 3 patches yourself (if you do not mind)
> >> - you have, for the whole series::
> >>
> >> Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> > Applied to the fixes-togreg branch of iio.git
> > 
> > Timing wise, these will now hit immediately after the merge window closes.
> 
> Greg, Jonathan,
> 
> I saw the IIO pull request a week ago ([PULL] IIO fixes for 3.15 round
> 1) but I do not see it in Linus' tree for the moment:
> http://article.gmane.org/gmane.linux.kernel.iio/11764

I don't have a copy of that pull request anywhere in my inboxes.  Was it
sent to me?  Did I loose it somewhere?

Oh crap, it ended up in my spam folder, very odd.  Gotta love gmail at
times...

I'll pull these in this week and get this to Linus for -rc3, sorry about
that.

greg k-h
