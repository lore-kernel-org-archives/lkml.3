Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934740AbaJ2RbZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 13:31:25 -0400
Received: from down.free-electrons.com ([37.187.137.238]:44464 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S934283AbaJ2RbX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 13:31:23 -0400
Date: Wed, 29 Oct 2014 18:31:20 +0100
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Kevin Hilman <khilman@kernel.org>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Olof Johansson <olof@lixom.net>
Subject: Re: [PATCH] pinctrl: at91: use own header
Message-ID: <20141029173119.GB17398@piout.net>
References: <1413539380-7046-1-git-send-email-alexandre.belloni@free-electrons.com>
 <CACRpkdbkVXCtaVY1S24bZ-q8vam729p0seGvvpKOL-AQQMywTQ@mail.gmail.com>
 <CAMAWPa_RuU73bPkxOwiqYjW3nH1DSCX+fOQ12T63SLiOVEBnyw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMAWPa_RuU73bPkxOwiqYjW3nH1DSCX+fOQ12T63SLiOVEBnyw@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kevin,


On 29/10/2014 at 10:17:56 -0700, Kevin Hilman wrote :
> On Tue, Oct 28, 2014 at 9:17 AM, Linus Walleij <linus.walleij@linaro.org> wrote:
> > On Fri, Oct 17, 2014 at 11:49 AM, Alexandre Belloni
> > <alexandre.belloni@free-electrons.com> wrote:
> >
> >> Copy the mach/at91_pio.h header locally and use it for pinctrl-at91.c. This
> >> allows to remove the dependency on mach/at91_pio.h to be able to move at91 to
> >> multiplatform.
> >>
> >> Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
> >
> > Patch applied to the pinctrl tree with Nicolas' ACK.
> 
> This patch broke the build for sama5_defconfig in next-20141029[1], as
> well as the other at91*defconfigs.
> 

It should be solved by now, the fix as been squashed in the offending
commit.

-- 
Alexandre Belloni, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
