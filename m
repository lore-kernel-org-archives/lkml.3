Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752240Ab3ATNy2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2013 08:54:28 -0500
Received: from mx.scalarmail.ca ([98.158.95.75]:40510 "EHLO
	ironport-01.sms.scalar.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752039Ab3ATNy0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2013 08:54:26 -0500
Date: Sun, 20 Jan 2013 08:54:24 -0500 (EST)
From: Tom St Denis <tstdenis@elliptictech.com>
To: Alexander Holler <holler@ahsoftware.de>
Cc: Borislav Petkov <bp@alien8.de>, Eric Dumazet <erdnetdev@gmail.com>,
        "Waskiewicz Jr, Peter P" <peter.p.waskiewicz.jr@intel.com>,
        David Miller <davem@davemloft.net>,
        steffen klassert <steffen.klassert@secunet.com>,
        herbert@gondor.hengli.com.au, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Michal Kubecek <mkubecek@suse.cz>,
        Mike Galbraith <bitbucket@online.de>
Message-ID: <650108746.93086.1358690064783.JavaMail.root@elliptictech.com>
In-Reply-To: <50FBF25C.4030604@ahsoftware.de>
Subject: Re: IPsec AH use of ahash
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.17.19.111]
X-Mailer: Zimbra 7.2.1_GA_2790 (ZimbraWebClient - GC24 (Linux)/7.2.1_GA_2790)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



----- Original Message -----
> From: "Alexander Holler" <holler@ahsoftware.de>
> To: "Tom St Denis" <tstdenis@elliptictech.com>
> Cc: "Borislav Petkov" <bp@alien8.de>, "Eric Dumazet" <erdnetdev@gmail.com>, "Waskiewicz Jr, Peter P"
> <peter.p.waskiewicz.jr@intel.com>, "David Miller" <davem@davemloft.net>, "steffen klassert"
> <steffen.klassert@secunet.com>, herbert@gondor.apana.org.au, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
> "Michal Kubecek" <mkubecek@suse.cz>, "Mike Galbraith" <bitbucket@online.de>
> Sent: Sunday, 20 January, 2013 8:34:20 AM
> Subject: Re: IPsec AH use of ahash
> 
> Am 20.01.2013 13:56, schrieb Tom St Denis:
> 
> > You should really try running checkpatch.pl over code that's
> > already in the kernel before you call out new contributors on it.
> >
> > How is this supposed to not be adversarial when I can't even use
> > the Kernel source itself as a reference?
> 
> In case of the kernel the chicken and egg problem can be answered
> without any questions, most source existed before checkpatch.pl
> (evolved
> to the current state).

We clearly have different interpretations of the word "maintainer" then...  If they're not maintaining the code then are they really the maintainers of it?

Point is I copied accepted kernel code and was rejected because of "errors" that are in existing kernel code.  Similarly if I did the upgrade to AH to use AEAD I suspect it would be rejected for the same reason.

Tom
