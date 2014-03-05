Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755843AbaCEBkF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 20:40:05 -0500
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:11124
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753299AbaCEBkD convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 20:40:03 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(z579ehz98dI1432I14ffIzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzz1de098h8275dh6d523h1de097h5e7bkz2dh87h2a8h839h947hd25hf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1fe8h1ff5h209eh2216h22d0h2336h2438h2461h2487h24d7h2516h2545h255eh25cch25f6h1151h1155h)
X-FB-DOMAIN-IP-MATCH: fail
Date: Wed, 5 Mar 2014 09:39:56 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Evgeniy Polyakov <zbr@ioremap.net>
CC: Alexander Shiyan <shc_work@mail.ru>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sascha Hauer <kernel@pengutronix.de>
Subject: Re: [PATCH 1/4] w1: Remove excess dependencies on W1 for masters and
 slaves
Message-ID: <20140305013953.GB8784@S2101-09.ap.freescale.net>
References: <1393054191-8623-1-git-send-email-shc_work@mail.ru>
 <746741393963037@web21h.yandex.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <746741393963037@web21h.yandex.ru>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: sigmatel.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 04, 2014 at 11:57:17PM +0400, Evgeniy Polyakov wrote:
> Hi everyone
> 
> 22.02.2014, 11:30, "Alexander Shiyan" <shc_work@mail.ru>:
> > Configuration for masters and slaves is included only if W1 symbol
> > enabled, so no reason to check it once more.
> >
> > Signed-off-by: Alexander Shiyan <shc_work@mail.ru>
> > ---
> >  drivers/w1/masters/Kconfig | 3 +--
> >  drivers/w1/slaves/Kconfig  | 5 -----
> >  2 files changed, 1 insertion(+), 7 deletions(-)
> >
> > diff --git a/drivers/w1/masters/Kconfig b/drivers/w1/masters/Kconfig
> > index efc7f07..6ffe120 100644
> > --- a/drivers/w1/masters/Kconfig
> > +++ b/drivers/w1/masters/Kconfig
> > @@ -36,13 +36,12 @@ config W1_MASTER_DS2482
> >
> >  config W1_MASTER_MXC
> >          tristate "Freescale MXC 1-wire busmaster"
> > - depends on W1 && ARCH_MXC
> > + depends on ARCH_MXC
> 
> I know nothing about this arch, so while this first patch looks good, I can not say anything about the others :)

Others look good to me.  So,

Acked-by: Shawn Guo <shawn.guo@linaro.org>

