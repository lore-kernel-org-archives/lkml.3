Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752702Ab3AUAr7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2013 19:47:59 -0500
Received: from mx.scalarmail.ca ([98.158.95.75]:44105 "EHLO
	ironport-01.sms.scalar.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752495Ab3AUAr6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2013 19:47:58 -0500
Date: Sun, 20 Jan 2013 19:47:57 -0500 (EST)
From: Tom St Denis <tstdenis@elliptictech.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Borislav Petkov <bp@alien8.de>, Eric Dumazet <erdnetdev@gmail.com>,
        "Waskiewicz Jr, Peter P" <peter.p.waskiewicz.jr@intel.com>,
        David Miller <davem@davemloft.net>,
        steffen klassert <steffen.klassert@secunet.com>,
        herbert@gondor.hengli.com.au, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Michal Kubecek <mkubecek@suse.cz>,
        Mike Galbraith <bitbucket@online.de>
Message-ID: <1926711985.94035.1358729277262.JavaMail.root@elliptictech.com>
In-Reply-To: <20130120220721.GA5434@home.goodmis.org>
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
> From: "Steven Rostedt" <rostedt@goodmis.org>
> To: "Tom St Denis" <tstdenis@elliptictech.com>
> Cc: "Borislav Petkov" <bp@alien8.de>, "Eric Dumazet" <erdnetdev@gmail.com>, "Waskiewicz Jr, Peter P"
> <peter.p.waskiewicz.jr@intel.com>, "David Miller" <davem@davemloft.net>, "steffen klassert"
> <steffen.klassert@secunet.com>, herbert@gondor.apana.org.au, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
> "Michal Kubecek" <mkubecek@suse.cz>, "Mike Galbraith" <bitbucket@online.de>
> Sent: Sunday, 20 January, 2013 5:07:22 PM
> Subject: Re: IPsec AH use of ahash
> 
> On Sun, Jan 20, 2013 at 07:56:27AM -0500, Tom St Denis wrote:
> > 
> > You should really try running checkpatch.pl over code that's
> > already in the kernel before you call out new contributors on it.
> > 
> > How is this supposed to not be adversarial when I can't even use
> > the Kernel source itself as a reference?
> 
> So there's a lot of crap code in the kernel (that we are trying to
> clean
> up when we have the time... see Kernel Janitors). But that's still no
> excuse to allow more crap code to enter. That means adding more crap
> to
> clean up.

Nowhere in the coding guidelines I've seen thus far says that you have to comment or document your code.

I wouldn't consider fixing "crap" code to mean to change indentation style [unless the original is horrible].  It's pointless busy work at best.

If you want to improve the quality of the code I'd start with /* and end with */ once in a while.

Tom
