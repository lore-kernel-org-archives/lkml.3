Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932105AbaCPT3Q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2014 15:29:16 -0400
Received: from top.free-electrons.com ([176.31.233.9]:54652 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754261AbaCPT3O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2014 15:29:14 -0400
Date: Sun, 16 Mar 2014 20:29:02 +0100
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Jonathan Cameron <jic23@kernel.org>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-iio@vger.kernel.org, linux-input@vger.kernel.org,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Gregory Clement <gregory.clement@free-electrons.com>
Subject: Re: [PATCH 00/15] iio: adc: at91 cleanups and atmel_tsadcc removal
Message-ID: <20140316192901.GK3106@piout.net>
References: <1394040940-18246-1-git-send-email-alexandre.belloni@free-electrons.com>
 <5325EDAF.4060003@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5325EDAF.4060003@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 16/03/2014 at 18:30:07 +0000, Jonathan Cameron wrote :
> On 05/03/14 17:35, Alexandre Belloni wrote:
> >This patch set is a followup of my previous series: iio: adc: at91 fixes
> >
> >I'm sorry it is so long, I made sure this is bissectable.
> It's a nice series, don't apologise for doing things right!
> 
> Clearly there are a few outstanding snippets from the reviews so far, but we
> are getting to the point where we need to agree on a path for this.  I'm
> happy to take the whole series through the IIO tree if Dmitry and the at91
> maintainers are happy with that.  If it is considered two invasive form the
> atmel side then I'm perfectly happy with someone to take it through the relevant
> platform tree instead.
> 
> I'm obviously not going to pick it up at all until it has a complete set
> of at91 maintainer acks though!
> 

Thank you for your review.

I already have a v2 ready addressing the received comments. I was mostly
waiting on your feedback and you seem happy with it. I'll send an update
on monday with the collected acks.

I'll let the at91 maintainer ack it and decide on the path.

> Realistically it's missed the coming merge window anyway, so we have a fair
> bit of time.
> 

That's why I've separated that series from the other fixes, this was not
as urgent.

-- 
Alexandre Belloni, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
