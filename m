Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752798AbaAFGaF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 01:30:05 -0500
Received: from mail-qc0-f178.google.com ([209.85.216.178]:63736 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751218AbaAFGaB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 01:30:01 -0500
MIME-Version: 1.0
In-Reply-To: <20140106172243.8067c8e72c666511129a9701@canb.auug.org.au>
References: <20131213125716.f432c59bf8782a489400a5a7@canb.auug.org.au>
	<20131217132838.cc16a4dbac2f4d3218bbed1d@canb.auug.org.au>
	<CAA+hA=Shwn1P25+xB+VogD+9n7gdvCmJ-EG6khgf3a2gjGwTJQ@mail.gmail.com>
	<20131217031600.GG6691@S2101-09.ap.freescale.net>
	<CAA+hA=QU1TApbbohD1iNFiMMMHdQSamRfOsO0r3GpqmCbdiSgw@mail.gmail.com>
	<20140106172243.8067c8e72c666511129a9701@canb.auug.org.au>
Date: Mon, 6 Jan 2014 14:30:00 +0800
Message-ID: <CAA+hA=TDJM_OAh=WFd5mqsix9-ZQuPvzXe_xHH0z+4xSZRRsBg@mail.gmail.com>
Subject: Re: linux-next: build failure after merge of the mmc tree
From: Dong Aisheng <dongas86@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Shawn Guo <shawn.guo@linaro.org>, Chris Ball <cjb@laptop.org>,
        linux-next@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dong Aisheng <b29396@freescale.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Shawn,

How do you suggest to fix this issue?
Can we cook a patch for it directly based on linux-next tree?

Regards
Dong Aisheng

On Mon, Jan 6, 2014 at 2:22 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi all,
>
> On Tue, 17 Dec 2013 16:06:19 +0800 Dong Aisheng <dongas86@gmail.com> wrote:
>>
>> I tested that Chris tree does not have problem.
>> It's caused by IMX tree updates.
>>
>> Chris,
>> Is the way Shawn suggested OK for you?
>
> Can we have some resolution of this please?  This failed to build again
> today so I have used the version of the mmc tree from next-20131212
> again.  I tried the obvious fix (s/pinctrl_usdhc4_1/pinctrl_usdhc4/) but
> that didn't work.
>
> --
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
