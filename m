Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932100AbaDHNrw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 09:47:52 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:40656 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756871AbaDHNrr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 09:47:47 -0400
Message-ID: <1396964805.28420.53.camel@iivanov-dev>
Subject: Re: [PATCH 2/2] ARM: dts: MSM8974: Add pinctrl node
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: Timur Tabi <timur@codeaurora.org>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>, devicetree@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>, linux-arm-msm@vger.kernel.org
Date: Tue, 08 Apr 2014 16:46:45 +0300
In-Reply-To: <5343EC87.700@codeaurora.org>
References: <1391700529-11816-1-git-send-email-iivanov@mm-sol.com>
		 <1391700529-11816-2-git-send-email-iivanov@mm-sol.com>
		 <CAOZdJXVE7MSMBaL+bt0kjw5LEidz-aVp+vrWqQWkye6HdE7EeA@mail.gmail.com>
	 <1396959284.28420.45.camel@iivanov-dev> <5343EC87.700@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.1-2ubuntu2~saucy1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-04-08 at 07:33 -0500, Timur Tabi wrote:
> Ivan T. Ivanov wrote:
> >> >I'm confused by this.  Isn't this information already defined in the
> >> >pinctrl-msm8x74.c driver?
> >> >
> >> >static const char * const blsp_spi8_groups[] = {
> >> >     "gpio45", "gpio46", "gpio47", "gpio48"
> >> >};
> > I am not sure that I understand the question. This is one of
> > possible ways to describe relationship between pins and functions.
> > As they are described is visible what is their real purpose.
> 
> Ok, let me rephrase.
> 
> The 8x74 pinctrl driver already contains this information.  It already 
> defines a "blsp_spi8" group consisting of GPIOs 45, 46, 47, and 48.
> 
> This patch adds that same exact information into the device tree.  Why 
> are we duplicating that information?  Why add it to the device tree when 
> it's already in the driver (and already working).

Probably. It was my natural way of thinking. Pin have a functions. 
It is easier if I measure signals to just look at the device
tree file. What are you suggesting?

> 
> Also, I don't see any code anywhere that uses these new device tree nodes.

This is easy to fix :-).

Regards,
Ivan

