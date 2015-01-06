Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932337AbbAFTau (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 14:30:50 -0500
Received: from exprod5og122.obsmtp.com ([64.18.0.192]:49213 "HELO
	exprod5og122.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756635AbbAFTas (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 14:30:48 -0500
MIME-Version: 1.0
In-Reply-To: <20150105.231054.790363276763745624.davem@davemloft.net>
References: <20150105.224137.894770670718334587.davem@davemloft.net>
	<20150105.224235.1941007145649816230.davem@davemloft.net>
	<CAL85gmCGK54yK3sThVhGsatMVUS8+76LRwdDt4w9PUfppMJ3og@mail.gmail.com>
	<20150105.231054.790363276763745624.davem@davemloft.net>
Date: Tue, 6 Jan 2015 11:30:46 -0800
Message-ID: <CAL85gmDybxCB59UcpFm3NRR7bxG-_1xsmXAs3oehOujEoetiog@mail.gmail.com>
Subject: Re: [PATCH V2] net: eth: xgene: change APM X-Gene SoC platform
 ethernet to support ACPI
From: Feng Kan <fkan@apm.com>
To: David Miller <davem@davemloft.net>
Cc: patches <patches@apm.com>, netdev@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 5, 2015 at 8:10 PM, David Miller <davem@davemloft.net> wrote:
> From: Feng Kan <fkan@apm.com>
> Date: Mon, 5 Jan 2015 20:05:28 -0800
>
>> I see, I initially tried on the net-next tree which did not build for
>> me, failed somewhere else but builds xgene enet ok.
>> Then I tested on net/master which builds fine for me.
>> Would you please point me to the branch you are using?
>
> net-next
David, I am not sure what I am missing here. I encountered a lot of
errors while compiling
the net-next.git. Mostly complaining of implicit declaration of
functions. Once I fixed those,
the compilation passes fine for defconfig in arm64. By default OF
should be enabled for
the platform, I am not sure how to recreate this. I have tested the
image for OF and ACPI
and both works.
