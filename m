Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752058Ab3ATM4b (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2013 07:56:31 -0500
Received: from mx.scalarmail.ca ([98.158.95.75]:39570 "EHLO
	ironport-01.sms.scalar.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751809Ab3ATM43 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2013 07:56:29 -0500
Date: Sun, 20 Jan 2013 07:56:27 -0500 (EST)
From: Tom St Denis <tstdenis@elliptictech.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Eric Dumazet <erdnetdev@gmail.com>,
        "Waskiewicz Jr, Peter P" <peter.p.waskiewicz.jr@intel.com>,
        David Miller <davem@davemloft.net>,
        steffen klassert <steffen.klassert@secunet.com>,
        herbert@gondor.hengli.com.au, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Michal Kubecek <mkubecek@suse.cz>,
        Mike Galbraith <bitbucket@online.de>
Message-ID: <313650836.93071.1358686587647.JavaMail.root@elliptictech.com>
In-Reply-To: <20130120103132.GA16800@pd.tnic>
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
> From: "Borislav Petkov" <bp@alien8.de>
> To: "Mike Galbraith" <bitbucket@online.de>
> Cc: "Tom St Denis" <tstdenis@elliptictech.com>, "Eric Dumazet" <erdnetdev@gmail.com>, "Waskiewicz Jr, Peter P"
> <peter.p.waskiewicz.jr@intel.com>, "David Miller" <davem@davemloft.net>, "steffen klassert"
> <steffen.klassert@secunet.com>, herbert@gondor.apana.org.au, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
> "Michal Kubecek" <mkubecek@suse.cz>
> Sent: Sunday, 20 January, 2013 5:31:32 AM
> Subject: Re: IPsec AH use of ahash
> 
> On Sun, Jan 20, 2013 at 06:06:21AM +0100, Mike Galbraith wrote:
> > Sounds as though any patches you submit land on your dinner plate
> > just
> > like potatoes. Hand the cook a pot of half peeled potatoes, he/she
> > may
> > say try again.
> 
> And how he/she would say it! I've seen serious fights spring up from
> half-peeled potatoes so people better peel them right the first time.

You should really try running checkpatch.pl over code that's already in the kernel before you call out new contributors on it.

How is this supposed to not be adversarial when I can't even use the Kernel source itself as a reference?

Tom
