Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161643AbaKNTcc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 14:32:32 -0500
Received: from mailsec109.isp.belgacom.be ([195.238.20.105]:31380 "EHLO
	mailsec109.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1161455AbaKNTca (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 14:32:30 -0500
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.1 cv=hkFBDakPHWYIOok4y3pcivnmCJQbEK2MeX2RAJ8hs1E= c=1 sm=2
 a=IkcTkHD0fZMA:10 a=IJv9LcIfAAAA:8 a=IDsI0P-6XW0UrOo3YjoA:9 a=QEXdDO2ut3YA:10
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av8KAE9YZlTD7hTT/2dsb2JhbABbgw6BLoMGtj0GmwoCgR0WAQEBAQF9hAIBAQEDASNWBQsFBhgCAhgOAgJXBhMRiCcNu2KHAo8uAQEBBwIBH4EthRGKZAeCd4FUBateiWiDfTwwgksBAQE
Date: Fri, 14 Nov 2014 20:32:29 +0100 (CET)
From: Fabian Frederick <fabf@skynet.be>
Reply-To: Fabian Frederick <fabf@skynet.be>
To: Joe Perches <joe@perches.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>
Message-ID: <47990659.56515.1415993549555.open-xchange@webmail.nmp.skynet.be>
In-Reply-To: <1415992486.5912.23.camel@perches.com>
References: <1415990202-28673-1-git-send-email-fabf@skynet.be> <1415990835.5912.20.camel@perches.com> <2104595537.56209.1415991758726.open-xchange@webmail.nmp.skynet.be> <1415992486.5912.23.camel@perches.com>
Subject: Re: [PATCH 1/1 net-next] net: dsa: replace count*size kmalloc by
 kmalloc_array
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Priority: 3
Importance: Medium
X-Mailer: Open-Xchange Mailer v7.2.2-Rev27
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> On 14 November 2014 at 20:14 Joe Perches <joe@perches.com> wrote:
>
>
> On Fri, 2014-11-14 at 20:02 +0100, Fabian Frederick wrote:
> > On 14 November 2014 at 19:47 Joe Perches <joe@perches.com> wrote:
> > > On Fri, 2014-11-14 at 19:36 +0100, Fabian Frederick wrote:
> > > > kmalloc_array manages count*sizeof overflow.
> > >
> > > Fundamentally correct, but is this necessary or useful?
> > > sizeof(s8) isn't often going to be anything other than 1.
> > Absolutely, I thought it was a struct :)
> >
> > There must be a reason for so many cases though ...
>
> Some might be style symmetry for other sizeof(othertype)
> uses in the same paths, but most of them are just overkill
> or maybe lack of understanding.
>
> s8 is char so by definition it has to be 1.
>
> I doubt any of the code dates from PDP-8/TOPS-10 days.
>
>
95% comes from drivers tree. I guess one patch to Greg would be enough.
Are you interested in those patches or can I do them with some "Suggested-by" ?
