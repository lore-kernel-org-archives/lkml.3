Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759152Ab3FMXxm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 19:53:42 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:52757 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759089Ab3FMXxl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 19:53:41 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-arm-kernel@lists.infradead.org
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>,
        James Hogan <james.hogan@imgtec.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Patrice Chotard <patrice.chotard.st@gmail.com>
Subject: Re: [PATCH 1/2] pinctrl: add function to parse generic pinconfig properties from a dt node
Date: Fri, 14 Jun 2013 01:53:49 +0200
Message-ID: <1862891.4yIecp615h@avalon>
User-Agent: KMail/4.10.2 (Linux/3.8.13-gentoo; KDE/4.10.2; x86_64; ; )
In-Reply-To: <CACRpkdZavNX3jk4K5unEJCED4vTuZEUF=NC1naGOMyr54hXQKw@mail.gmail.com>
References: <201306102139.32444.heiko@sntech.de> <201306131723.04721.heiko@sntech.de> <CACRpkdZavNX3jk4K5unEJCED4vTuZEUF=NC1naGOMyr54hXQKw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On Thursday 13 June 2013 17:36:00 Linus Walleij wrote:
> On Thu, Jun 13, 2013 at 5:23 PM, Heiko Stübner <heiko@sntech.de> wrote:
> >> Ok, I'll see that I get this fixed :-)
> > 
> > Hmm ... what is the meaning of the argument of bias-disable and bias-high-
> > impedance, as the kernel-doc in pinconf-generic.h does not tell?
> 
> I think those arguments are N/A, ignored, doesn't matter.
> If these options were typed, they would be bool.
> 
> Please improve documentation if you can... sorry for all the
> rough edges.
> 
> > bias-bus-hold ignores its argument and we already clarified that the
> > pull-* do have != 0 or 0 argument.
> 
> I think in the DT binding, both these forms:
> 
> bias-pull-up;
> bias-pull-up = <150000>;
> 
> Should be allowed.
> 
> So when parsing, you first check if it exists, then if there
> is an argument, if there is no value supplied, just set it
> to 1, as that is clearly != 0...

What's the expected way to disable pull-ups in DT ? Should it be 'bias-pull-up 
= <0>;' or 'bias-disable;' ?

-- 
Regards,

Laurent Pinchart

