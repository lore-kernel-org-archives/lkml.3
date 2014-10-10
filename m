Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751849AbaJJIlX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 04:41:23 -0400
Received: from mailsec115.isp.belgacom.be ([195.238.20.111]:4269 "EHLO
	mailsec115.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751174AbaJJIlR convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 04:41:17 -0400
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.1 cv=cGhLeOE9I35BcZRK2zxy3BlNJEt3JpyFGdx+8CmfgKw= c=1 sm=2
 a=IkcTkHD0fZMA:10 a=DswfTcTIAAAA:8 a=gu6fZOg2AAAA:8
 a=Ih2bRtmGg2PMunX3RE0A:9 a=QEXdDO2ut3YA:10 a=JfjM6313LcIA:10
 a=GC8p-B92FUEA:10 a=NWVoK91CQyQA:10
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AjoLALSaN1TD7hTU/2dsb2JhbABggw5TWIMGtGsBAQEBAQEGkzyHTQKBCBYBe4QDAQEBAwEjVgULBQQCGAICGA4CAlcGARIRiCUMCZEVnE2Gf44SAQEBAQYBAQEBHoEshHSJcTMHgneBVAWWO4h6lCeDeTsvgkoBAQE
Date: Fri, 10 Oct 2014 10:41:15 +0200 (CEST)
From: Fabian Frederick <fabf@skynet.be>
Reply-To: Fabian Frederick <fabf@skynet.be>
To: Julia Lawall <julia.lawall@lip6.fr>,
        Ilya Dryomov <ilya.dryomov@inktank.com>,
        Dan Mick <dan.mick@inktank.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ceph Development <ceph-devel@vger.kernel.org>,
        Sage Weil <sage@inktank.com>
Message-ID: <1754653714.36927.1412930475803.open-xchange@webmail.nmp.skynet.be>
In-Reply-To: <CALFYKtB8Z4HHr5ZuLcMdctOKBSZZjgCAhbOiFHgbPnVcbjLySw@mail.gmail.com>
References: <1412889395-19350-1-git-send-email-fabf@skynet.be> <54372B43.2010801@inktank.com> <CALFYKtB8Z4HHr5ZuLcMdctOKBSZZjgCAhbOiFHgbPnVcbjLySw@mail.gmail.com>
Subject: Re: [PATCH 1/1 linux-next] ceph: fix bool assignments
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Priority: 3
Importance: Medium
X-Mailer: Open-Xchange Mailer v7.2.2-Rev27
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> On 10 October 2014 at 10:24 Ilya Dryomov <ilya.dryomov@inktank.com> wrote:
>
>
> On Fri, Oct 10, 2014 at 4:41 AM, Dan Mick <dan.mick@inktank.com> wrote:
> >
> >
> > On 10/09/2014 02:16 PM, Fabian Frederick wrote:
> >> Fix some coccinelle warnings:
> >> fs/ceph/caps.c:2400:6-10: WARNING: Assignment of bool to 0/1
> >
> >
> >> -     bool wake = 0;
> >> +     bool wake = false;
> >
> > FWIW, that message is backwards: it should say "WARNING: Assignment of
> > 0/1 to bool" (I know, it's a coccinelle issue, but..)
>
> Hi Julia,
>
> See above, hopefully you are the right person to ask to forward this to
> the right people ;)
>
> Thanks,
>
>                 Ilya
Hi Ilya,

    Patch already send and acked:
http://marc.info/?l=linux-kernel&m=141292553109418&w=2

Regards,
Fabian
