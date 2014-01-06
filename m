Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752838AbaAFGqm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 01:46:42 -0500
Received: from mail-qe0-f50.google.com ([209.85.128.50]:38151 "EHLO
	mail-qe0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751336AbaAFGqk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 01:46:40 -0500
MIME-Version: 1.0
In-Reply-To: <20140106064600.GE26128@S2101-09.ap.freescale.net>
References: <20131213125716.f432c59bf8782a489400a5a7@canb.auug.org.au>
	<20131217132838.cc16a4dbac2f4d3218bbed1d@canb.auug.org.au>
	<CAA+hA=Shwn1P25+xB+VogD+9n7gdvCmJ-EG6khgf3a2gjGwTJQ@mail.gmail.com>
	<20131217031600.GG6691@S2101-09.ap.freescale.net>
	<CAA+hA=QU1TApbbohD1iNFiMMMHdQSamRfOsO0r3GpqmCbdiSgw@mail.gmail.com>
	<20140106172243.8067c8e72c666511129a9701@canb.auug.org.au>
	<CAA+hA=TDJM_OAh=WFd5mqsix9-ZQuPvzXe_xHH0z+4xSZRRsBg@mail.gmail.com>
	<20140106064600.GE26128@S2101-09.ap.freescale.net>
Date: Mon, 6 Jan 2014 14:46:39 +0800
Message-ID: <CAA+hA=RZdT=Nz6P+TYtSHxPvA0WwsZUsod=FnBU7OtZa=8GtTQ@mail.gmail.com>
Subject: Re: linux-next: build failure after merge of the mmc tree
From: Dong Aisheng <dongas86@gmail.com>
To: Shawn Guo <shawn.guo@linaro.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Chris Ball <cjb@laptop.org>,
        linux-next@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dong Aisheng <b29396@freescale.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 6, 2014 at 2:46 PM, Shawn Guo <shawn.guo@linaro.org> wrote:
> On Mon, Jan 06, 2014 at 02:30:00PM +0800, Dong Aisheng wrote:
>> Hi Shawn,
>>
>> How do you suggest to fix this issue?
>> Can we cook a patch for it directly based on linux-next tree?
>
> No, we can not.  No patch should be targeting linux-next tree.  I just
> gave a resolution to Stephen.  Before Chris shows up and drops the patch
> from his tree, we will need to use that temp resolution.
>

Got it, thanks.

Regards
Dong Aisheng

> Shawn
>
