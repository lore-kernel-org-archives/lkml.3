Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752283Ab3ATOMa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2013 09:12:30 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:55848 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752250Ab3ATOMZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2013 09:12:25 -0500
Message-ID: <1358691094.5705.40.camel@marge.simpson.net>
Subject: Re: IPsec AH use of ahash
From: Mike Galbraith <bitbucket@online.de>
To: Tom St Denis <tstdenis@elliptictech.com>
Cc: Eric Dumazet <erdnetdev@gmail.com>,
        "Waskiewicz Jr, Peter P" <peter.p.waskiewicz.jr@intel.com>,
        David Miller <davem@davemloft.net>,
        steffen klassert <steffen.klassert@secunet.com>,
        herbert@gondor.hengli.com.au, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Michal Kubecek <mkubecek@suse.cz>
Date: Sun, 20 Jan 2013 15:11:34 +0100
In-Reply-To: <1331637866.93068.1358686536347.JavaMail.root@elliptictech.com>
References: <1331637866.93068.1358686536347.JavaMail.root@elliptictech.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:h5XovZAvJ+IZ3RwqWkKdRqQTDZ84IrJjciQb5F9yO0F
 k1FnAzbnAcEHRBGVpQOU53sW7P8vgyoghZBu9fPzMtlhmyxhI+
 nVIUpUl2I6YdeHGs7H0eGKlU/Fsi+6+TYjNpMJ7qbDsAzuGrIM
 V8f2YKLG0r5lxXZcY1IhSbcMDy7FtwpeCV1wS9dlc92YgJyFVr
 ZqOh38vyakuEPb28RzmQTFuH1+DYHVPzwRCuE07sHYaYFsDH0d
 CfLMC1oTB3OHIgT4nHSUeGGAxDb0pKbYPLn7LJ1jkHN2FAwr5V
 HAABwTmapsnk+gt0TLY62P/sO8kAz0Bam39Y29MWbwWLFZBcE3
 EYWev2xSnxKHsKtk6rI6Z79Ingv/JiuVP9j2UWI6ns3zFAA7N4
 adMKeAzXNuvdw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2013-01-20 at 07:55 -0500, Tom St Denis wrote: 
> 
> ----- Original Message -----
> > From: "Mike Galbraith" <bitbucket@online.de>
> > To: "Tom St Denis" <tstdenis@elliptictech.com>
> > Cc: "Eric Dumazet" <erdnetdev@gmail.com>, "Waskiewicz Jr, Peter P" <peter.p.waskiewicz.jr@intel.com>, "David Miller"
> > <davem@davemloft.net>, "steffen klassert" <steffen.klassert@secunet.com>, herbert@gondor.apana.org.au,
> > linux-kernel@vger.kernel.org, netdev@vger.kernel.org, "Michal Kubecek" <mkubecek@suse.cz>
> > Sent: Sunday, 20 January, 2013 12:06:21 AM
> > Subject: Re: IPsec AH use of ahash
> > 
> > On Sat, 2013-01-19 at 05:30 -0500, Tom St Denis wrote:
> > 
> > > For those of us who do Kernel development during business hours
> > > it's
> > > hard to justify the work when the path to mainline is convoluted
> > > and
> > > landmined.
> > 
> > Sounds as though any patches you submit land on your dinner plate
> > just
> > like potatoes.  Hand the cook a pot of half peeled potatoes, he/she
> > may
> > say try again.  The result of a little extra effort is tastier taters
> > for everybody feasting at the common table.. including you.
> 
> No, in reality what happened is the chef made potatos [incorrectly]
> got busy and asked others to help out and make more potatos.  Then
> came back and said ...

Bottom line: either you grit your teeth and try again or you don't.
Calling the chef a big meanie doesn't put taters on dinner plates.

-Mike

