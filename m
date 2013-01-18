Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754872Ab3ARTfg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 14:35:36 -0500
Received: from mx.scalarmail.ca ([98.158.95.75]:1335 "EHLO
	ironport-01.sms.scalar.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753930Ab3ARTff (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 14:35:35 -0500
Date: Fri, 18 Jan 2013 14:35:33 -0500 (EST)
From: Tom St Denis <tstdenis@elliptictech.com>
To: Steffen Klassert <steffen.klassert@secunet.com>
Cc: herbert@gondor.hengli.com.au, davem@davemloft.net,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Message-ID: <396283550.90353.1358537733820.JavaMail.root@elliptictech.com>
In-Reply-To: <20130116062104.GA18940@secunet.com>
Subject: Re: IPsec AH use of ahash
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.17.19.111]
X-Mailer: Zimbra 7.2.1_GA_2790 (ZimbraWebClient - GC24 (Linux)/7.2.1_GA_2790)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Any "maintainers" going to reply to this at all?  

Tom

----- Original Message -----
> From: "Steffen Klassert" <steffen.klassert@secunet.com>
> To: "Tom St Denis" <tstdenis@elliptictech.com>
> Cc: herbert@gondor.apana.org.au, davem@davemloft.net, linux-kernel@vger.kernel.org, netdev@vger.kernel.org
> Sent: Wednesday, 16 January, 2013 1:21:04 AM
> Subject: Re: IPsec AH use of ahash
> 
> Please Cc netdev@vger.kernel.org on all networking related topics.
> 
> On Tue, Jan 15, 2013 at 11:51:48AM -0500, Tom St Denis wrote:
> > Hi all,
> > 
> > The AH4/6 code uses ahash to perform the MAC calculation but this
> > precludes the availability of GMAC to the user.  Are there any
> > plans to port the AH code over to the aead API so that it can use
> > potentially any algo available to the user?
> > 
> 
> There was no need for this by now, but you are welcome
> to send patches.
> 
