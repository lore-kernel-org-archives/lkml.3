Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759195Ab3FMSdl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 14:33:41 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:35530 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759121Ab3FMSdX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 14:33:23 -0400
Message-ID: <1371148401.31941.20.camel@joe-AO722>
Subject: Re: [PATCH v3] ethernet/arc/arc_emac - Add new driver
From: Joe Perches <joe@perches.com>
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Alexey Brodkin <Alexey.Brodkin@synopsys.com>,
        netdev <netdev@vger.kernel.org>,
        Francois Romieu <romieu@fr.zoreil.com>,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        Mischa Jonker <Mischa.Jonker@synopsys.com>,
        Arnd Bergmann <arnd@arndb.de>, Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Devicetree Discuss <devicetree-discuss@lists.ozlabs.org>
Date: Thu, 13 Jun 2013 11:33:21 -0700
In-Reply-To: <CAHp75Vf4zjtebbaQMp4L0EmUPDVyrNPfvLODo7gHBuBEsWmZeA@mail.gmail.com>
References: <1371134239-4531-1-git-send-email-abrodkin@synopsys.com>
	 <CAHp75Vf4zjtebbaQMp4L0EmUPDVyrNPfvLODo7gHBuBEsWmZeA@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-06-13 at 21:25 +0300, Andy Shevchenko wrote:
> On Thu, Jun 13, 2013 at 5:37 PM, Alexey Brodkin
> <Alexey.Brodkin@synopsys.com> wrote:
> > Driver for non-standard on-chip ethernet device ARC EMAC 10/100,
> > instantiated in some legacy ARC (Synopsys) FPGA Boards such as
> > ARCAngel4/ML50x.
> 
> Much better. But still few comments below.

Sensible comments save for this truly trivial one

> > +++ b/drivers/net/ethernet/arc/arc_emac.h
[]
> > +               if (unlikely((info & OWN_MASK) == FOR_EMAC)) {
> > +                       /* BD is still owned by EMAC */
> > +                       continue;
> > +               }
> 
> Redundant braces.

Maybe not.  Braces can be a visual aid when there is
a comment in the test.


