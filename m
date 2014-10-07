Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755274AbaJGUtf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 16:49:35 -0400
Received: from mailsec111.isp.belgacom.be ([195.238.20.107]:45549 "EHLO
	mailsec111.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754139AbaJGUte convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 16:49:34 -0400
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.1 cv=Daq5x7peQTZG5JcO7WbcljS9mPiqDMY23hclUajVz3U= c=1 sm=2
 a=IkcTkHD0fZMA:10 a=_jlGtV7tAAAA:8 a=xf9U0QoNmvh8aYnQ4aMA:9
 a=QEXdDO2ut3YA:10 a=L1RTw_NLzc0A:10
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AlMLAI1RNFTD7hTT/2dsb2JhbABfgw6BK4MEtW0BAQEBAQEGmngCgREWAXuEAwEBAQMBI1YFCwUGDgYBAwICGA4CAlcGARIRiCUMrUSGf44HAReBLIR0iXEzB4J3gVQFqhqJMINlOy+CSgEBAQ
Date: Tue, 7 Oct 2014 22:49:31 +0200 (CEST)
From: Fabian Frederick <fabf@skynet.be>
Reply-To: Fabian Frederick <fabf@skynet.be>
To: Guenter Roeck <linux@roeck-us.net>, David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <1559212122.19553.1412714971908.open-xchange@webmail.nmp.skynet.be>
In-Reply-To: <20141007203344.GA4748@roeck-us.net>
References: <1412712996-4672-1-git-send-email-fabf@skynet.be> <20141007.161832.453892039501955243.davem@davemloft.net> <20141007203344.GA4748@roeck-us.net>
Subject: Re: [PATCH 1/1 net-next] af_unix: remove NULL assignment on static
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Priority: 3
Importance: Medium
X-Mailer: Open-Xchange Mailer v7.2.2-Rev27
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> On 07 October 2014 at 22:33 Guenter Roeck <linux@roeck-us.net> wrote:
>
>
> On Tue, Oct 07, 2014 at 04:18:32PM -0400, David Miller wrote:
> > From: Fabian Frederick <fabf@skynet.be>
> > Date: Tue,  7 Oct 2014 22:16:36 +0200
> >
> > > static values are automatically initialized to NULL
> > >
> > > Signed-off-by: Fabian Frederick <fabf@skynet.be>
> >
> > Isn't there some implementation room given to compilers
> > as to the representation of true and false?
>
> Not for true/false.
>
> C99 standard, section 7.16:
>
> ...
> The remaining three macros are suitable for use in #if preprocessing
> directives. They are
>
> true
>
> which expands to the integer constant 1,
>
> false
>
> which expands to the integer constant 0, and
> ...
>
> No idea where the NULL comes into the picture, though.
>
> Guenter

Maybe comment should have been "static values are automatically initialized to
0" then ?

Regards,
Fabian
