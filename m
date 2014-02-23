Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751212AbaBWN5Y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Feb 2014 08:57:24 -0500
Received: from mail-pb0-f45.google.com ([209.85.160.45]:36080 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751092AbaBWN5X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Feb 2014 08:57:23 -0500
Date: Sun, 23 Feb 2014 05:57:25 -0800
From: Olof Johansson <olof@lixom.net>
To: Christian Daudt <bcm@fixthebug.org>
Cc: Matt Porter <mporter@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Kevin Hilman <khilman@linaro.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2] MAINTAINERS: add additional ARM BCM281xx/BCM11xxx
 maintainer
Message-ID: <20140223135725.GA10833@quad.lixom.net>
References: <1392390903-19826-1-git-send-email-mporter@linaro.org>
 <CAEPRUYqxHwSYVPV-1Td3dHsBydDybJh5YLY0+GoN+vnakGaTtw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEPRUYqxHwSYVPV-1Td3dHsBydDybJh5YLY0+GoN+vnakGaTtw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 14, 2014 at 08:37:41AM -0800, Christian Daudt wrote:
> On Fri, Feb 14, 2014 at 7:15 AM, Matt Porter <mporter@linaro.org> wrote:
> > Add myself as an additional maintainer for the Broadcom mobile
> > SoCs.
> >
> > Signed-off-by: Matt Porter <mporter@linaro.org>
> > ---
> > Since v1: put back my missing SOB
> >
> >  MAINTAINERS | 1 +
> >  1 file changed, 1 insertion(+)
> >
> > diff --git a/MAINTAINERS b/MAINTAINERS
> > index b2cf5cf..9d6fbfd 100644
> > --- a/MAINTAINERS
> > +++ b/MAINTAINERS
> > @@ -1860,6 +1860,7 @@ F:        drivers/net/ethernet/broadcom/bnx2x/
> >
> >  BROADCOM BCM281XX/BCM11XXX ARM ARCHITECTURE
> >  M:     Christian Daudt <bcm@fixthebug.org>
> > +M:     Matt Porter <mporter@linaro.org>
> >  L:     bcm-kernel-feedback-list@broadcom.com
> >  T:     git git://git.github.com/broadcom/bcm11351
> >  S:     Maintained
> > --
> > 1.8.4
> >
> Acked-by: Christian Daudt <bcm@fixthebug.org>

Applied to fixes, thanks.


-Olof
