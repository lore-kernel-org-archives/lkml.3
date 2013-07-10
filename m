Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754238Ab3GJMuz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 08:50:55 -0400
Received: from ud10.udmedia.de ([194.117.254.50]:53895 "EHLO
	mail.ud10.udmedia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752561Ab3GJMux (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 08:50:53 -0400
Date: Wed, 10 Jul 2013 14:50:51 +0200
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: Josh Boyer <jwboyer@gmail.com>
Cc: David Miller <davem@davemloft.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        netdev <netdev@vger.kernel.org>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        Alexey Brodkin <Alexey.Brodkin@synopsys.com>
Subject: Re: [GIT] Networking
Message-ID: <20130710125051.GB357@x4>
References: <20130709.145325.1363244885668360965.davem@davemloft.net>
 <20130710122523.GA357@x4>
 <CA+5PVA5AT0OLNi-=x91ks5AbigymE3BDmdoEiiNOeRoGFCFQfg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+5PVA5AT0OLNi-=x91ks5AbigymE3BDmdoEiiNOeRoGFCFQfg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013.07.10 at 08:43 -0400, Josh Boyer wrote:
> On Wed, Jul 10, 2013 at 8:25 AM, Markus Trippelsdorf
> <markus@trippelsdorf.de> wrote:
> > On 2013.07.09 at 14:53 -0700, David Miller wrote:
> >>
> >> Alexey Brodkin (2):
> >>       ethernet/arc/arc_emac - Add new driver
> >>       arc_emac: fix compile-time errors & warnings on PPC64
> >
> > This driver defaults to y for no reason:
> >
> > +config NET_VENDOR_ARC
> > +       bool "ARC devices"
> > +       default y
> 
> That's the option to enable the ARC vendor, not the driver.  The
> driver config option is ARC_EMAC.  All of the other ethernet vendors
> also default to y, so I don't think this is out of line.

Ah, I just noticed it while running "make" on the freshly pulled kernel
tree. 
But you're right.  Sorry for the noise.

-- 
Markus
