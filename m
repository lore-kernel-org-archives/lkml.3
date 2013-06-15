Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754804Ab3FOXws (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jun 2013 19:52:48 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:38251 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754729Ab3FOXwr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jun 2013 19:52:47 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        James Hogan <james.hogan@imgtec.com>,
        "linux-sh@vger.kernel.org" <linux-sh@vger.kernel.org>
Subject: Re: [RFC] pinctrl: generic: Add DT bindings
Date: Sun, 16 Jun 2013 01:52:59 +0200
Message-ID: <1422045.RvRkWGR9K7@avalon>
User-Agent: KMail/4.10.2 (Linux/3.8.13-gentoo; KDE/4.10.2; x86_64; ; )
In-Reply-To: <CACRpkdYi=ekV8okmz68HZ8Ydv9hTrHnHvQh0HYMs5SfURd9mdA@mail.gmail.com>
References: <1370988237-30593-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com> <1795038.rqcr6GWLdP@avalon> <CACRpkdYi=ekV8okmz68HZ8Ydv9hTrHnHvQh0HYMs5SfURd9mdA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On Sunday 16 June 2013 01:51:32 Linus Walleij wrote:
> On Sun, Jun 16, 2013 at 1:35 AM, Laurent Pinchart wrote:
> > On Saturday 15 June 2013 22:16:13 Heiko Stübner wrote:
> >> Am Samstag, 15. Juni 2013, 21:56:05 schrieb Linus Walleij:
> >> 
> >> Disable would the be either
> >> 
> >>       bias-disable;
> >> 
> >> or
> >> 
> >>       bias-pull-up = <0>;
> >> 
> >> A driver should probably handle both, as both are valid pinconf options
> >> or this.
> > 
> > I feel a bit uneasy about that. Do we really need to support two different
> > ways to achieve the same result ?
> 
> In this specific case I think yes, but not on all options.
> 
> As dicussed earlier this was designed for systems where
> you could set the pull-up resistance, like
> 
> bias-pull-up = <600000>;
> 
> would give 600kOhm pull up.
> 
> In most existing systems that is silly, as they can't specify it, so they
> should be able to do just:
> 
> bias-pull-up;
> 
> as that is all they can do. If we have to cut one way, we should cut the
> former until such a system appears.

I'm fine with bias-pull-up = <1>; vs bias-pull-up;. What bothers me a bit is 
bias-pull-up = <0>; vs bias-disable;.

-- 
Regards,

Laurent Pinchart

