Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753330AbaJFSdF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 14:33:05 -0400
Received: from mailsec102.isp.belgacom.be ([195.238.20.98]:20441 "EHLO
	mailsec102.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753227AbaJFSdC convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 14:33:02 -0400
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.1 cv=xmGiAQlKtCF5+ra7FDB8hpYjXxwBLBdzsqYiSFHyMzI= c=1 sm=2
 a=IkcTkHD0fZMA:10 a=VwQbUJbxAAAA:8 a=uP1ucDPQAAAA:8
 a=Fv3cAR0bPbasdMzbkYsA:9 a=QEXdDO2ut3YA:10 a=1JvJEtVdGvUA:10
 a=zaWHSuwd-w0A:10
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AhELAHffMlTD7hTS/2dsb2JhbABfgw5TWIMCtQ4BBpQPh0sCgQYWAXuEAwEBAQMBI1YFCwUGDgoCAhgOAgJGEQYTEYglDAmsa4Z/jVwBEwSBLIR0iUMRAR0zB4J3gVQFljCTYIkug2U7LwEBgQ2BOwEBAQ
Date: Mon, 6 Oct 2014 20:33:00 +0200 (CEST)
From: Fabian Frederick <fabf@skynet.be>
Reply-To: Fabian Frederick <fabf@skynet.be>
To: Borislav Petkov <bp@alien8.de>
Cc: linux-media@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org,
        iss_storagedev@hp.com
Message-ID: <2020432291.307101.1412620380646.open-xchange@webmail.nmp.skynet.be>
In-Reply-To: <20141006174050.GA20739@pd.tnic>
References: <1412609755-28627-1-git-send-email-fabf@skynet.be> <20141006174050.GA20739@pd.tnic>
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



> On 06 October 2014 at 19:40 Borislav Petkov <bp@alien8.de> wrote:
>
>
> On Mon, Oct 06, 2014 at 05:35:47PM +0200, Fabian Frederick wrote:
> > This small patchset removes IRQF_DISABLED from drivers branch.
> >
> > See include/linux/interrupt.h:
> > "This flag is a NOOP and scheduled to be removed"
> >
> > Note: (cross)compiled but untested.
> >
> > Fabian Frederick (7):
> >   mv64x60_edac: remove deprecated IRQF_DISABLED
> >   ppc4xx_edac: remove deprecated IRQF_DISABLED
>
> For the EDAC bits already applied Michael's patch:
>
> https://lkml.kernel.org/r/1412159043-7348-1-git-send-email-michael.opdenacker@free-electrons.com
>
> --
> Regards/Gruss,
>     Boris.

Hi Borislav,

   You're right, I guess we can forget this patchset.
I didn't see it was already done. (nothing in linux-next yet).
Sorry for the noise. 
 
Regards,
Fabian

>
> Sent from a fat crate under my desk. Formatting is fine.
> --
