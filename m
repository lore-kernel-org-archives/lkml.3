Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753344AbaJFTX6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 15:23:58 -0400
Received: from mailsec102.isp.belgacom.be ([195.238.20.98]:47661 "EHLO
	mailsec102.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753256AbaJFTX4 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 15:23:56 -0400
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.1 cv=xmGiAQlKtCF5+ra7FDB8hpYjXxwBLBdzsqYiSFHyMzI= c=1 sm=2
 a=IkcTkHD0fZMA:10 a=UcL70baaR2ipQ3Yuu2EA:9 a=QEXdDO2ut3YA:10
 a=1JvJEtVdGvUA:10
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgwLADHrMlTD7hTS/2dsb2JhbABfgw6BK4MCtQ4BBptaAoEGFgF7hAMBAQEDASNWBQsFBg4KAgIYDgICVwYTEYglDKxbhn+NYBiBLIR0iiUHgneBVAWea4slhS+Df4NlOy+CSgEBAQ
Date: Mon, 6 Oct 2014 21:23:54 +0200 (CEST)
From: Fabian Frederick <fabf@skynet.be>
Reply-To: Fabian Frederick <fabf@skynet.be>
To: Borislav Petkov <bp@alien8.de>
Cc: linux-media@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org,
        iss_storagedev@hp.com
Message-ID: <1381855926.311014.1412623434854.open-xchange@webmail.nmp.skynet.be>
In-Reply-To: <20141006184623.GC20739@pd.tnic>
References: <1412609755-28627-1-git-send-email-fabf@skynet.be> <20141006174050.GA20739@pd.tnic> <2020432291.307101.1412620380646.open-xchange@webmail.nmp.skynet.be> <20141006184623.GC20739@pd.tnic>
Subject: Re: [PATCH 0/7 linux-next] drivers: remove deprecated IRQF_DISABLED
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Priority: 3
Importance: Medium
X-Mailer: Open-Xchange Mailer v7.2.2-Rev27
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> On 06 October 2014 at 20:46 Borislav Petkov <bp@alien8.de> wrote:
>
>
> On Mon, Oct 06, 2014 at 08:33:00PM +0200, Fabian Frederick wrote:
> >    You're right, I guess we can forget this patchset.
> > I didn't see it was already done. (nothing in linux-next yet).
>
> Not the whole patchset - I was replying only to your two patches
> touching code in drivers/edac/. I don't know about the rest but yeah,
> checking linux-next is always a good idea.
>
> Also, did you CC the proper maintainers for the rest of your patches? If
> not, do that and see what they have to say.
>
> HTH.
>

CC list was ok. I'll keep an eye on linux-next and see with Michael
if he has other patches approved in the list.

Regards,
Fabian
 

> --
> Regards/Gruss,
>     Boris.
>
> Sent from a fat crate under my desk. Formatting is fine.
> --
