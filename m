Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756427AbaIEJc0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 05:32:26 -0400
Received: from cpsmtpb-ews02.kpnxchange.com ([213.75.39.5]:58528 "EHLO
	cpsmtpb-ews02.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755841AbaIEJcY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 05:32:24 -0400
Message-ID: <1409909543.5546.150.camel@x220>
Subject: Re: [PATCH 16/28] Remove GENERIC_HAS_IOMAP
From: Paul Bolle <pebolle@tiscali.nl>
To: Guenter Roeck <linux@roeck-us.net>, Richard Weinberger <richard@nod.at>
Cc: Lennox Wu <lennox.wu@gmail.com>, Chen Liqin <liqin.linux@gmail.com>,
        linux-kernel@vger.kernel.org
Date: Fri, 05 Sep 2014 11:32:23 +0200
In-Reply-To: <CAF0htA691-9ccAr1FX-7xdBgx+OYjv7bG0VRMzETj_=0HW9pUQ@mail.gmail.com>
References: <1391971686-9517-1-git-send-email-richard@nod.at>
	 <1391971686-9517-17-git-send-email-richard@nod.at>
	 <CAF0htA5xWQwkMqdp0_zz05DLJvyCOJZf-v1Rso20de5VWFmPTA@mail.gmail.com>
	 <1397553547.1985.25.camel@x220>
	 <CAF0htA403PKyAgQjrMpYgawNZWKZm06UYrgV-7N_9tbas=SniA@mail.gmail.com>
	 <1397673008.6361.0.camel@x220> <1403082609.1984.66.camel@x220>
	 <CAF0htA691-9ccAr1FX-7xdBgx+OYjv7bG0VRMzETj_=0HW9pUQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-3.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 05 Sep 2014 09:32:22.0908 (UTC) FILETIME=[4BF2E3C0:01CFC8EC]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Guenter, Richard,

On Thu, 2014-06-19 at 03:53 +0800, Lennox Wu wrote:
> 2014-06-18 17:10 GMT+08:00 Paul Bolle <pebolle@tiscali.nl>:
> >> On Wed, 2014-04-16 at 20:30 +0200, Paul Bolle wrote:
> >> On Thu, 2014-04-17 at 01:29 +0800, Lennox Wu wrote:
> >> > OK, we will merge it into our tree.
> >
> > The last few messages in this thread were sent shortly after v3.15-rc1.
> > We're now at v3.16-rc1 and those three references to GENERIC_HAS_IOMAP
> > are still there.
> >
> > Are there any issues with this patch?
> >
> >
> > Paul Bolle
> >
> NO, there is no issue. We just want to push patches in a batched way.
> The patch will show recently. Thank you.

And at v3.17-rc3 this patch has still not shown up in mainline. Do you
have suggestions for an alternative route to get this triviality finally
merged?


Paul Bolle

