Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753799Ab3ELPNt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 May 2013 11:13:49 -0400
Received: from mail-ve0-f172.google.com ([209.85.128.172]:55377 "EHLO
	mail-ve0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752839Ab3ELPNs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 May 2013 11:13:48 -0400
MIME-Version: 1.0
In-Reply-To: <CAHp75VfWzzevr6AQzE25P8FUXd=amzL5-XgkJXvbRDESF=M76A@mail.gmail.com>
References: <1368086241-9357-1-git-send-email-yefremov.denis@gmail.com>
	<1368091192-10245-4-git-send-email-yefremov.denis@gmail.com>
	<CAHp75VfWzzevr6AQzE25P8FUXd=amzL5-XgkJXvbRDESF=M76A@mail.gmail.com>
Date: Sun, 12 May 2013 20:43:47 +0530
X-Google-Sender-Auth: hd-nEE0ubHpp73yjOt5sSBe6nPM
Message-ID: <CAOh2x=nrTneXoWmVre7W3xMEYmbGcaFADcHCz4oNYAMVe9xR2A@mail.gmail.com>
Subject: Re: [PATCH 09/21] dw_dmac: remove inline marking of EXPORT_SYMBOL functions
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Denis Efremov <yefremov.denis@gmail.com>, trivial@kernel.org,
        ldv-project@linuxtesting.org, Dan Williams <djbw@fb.com>,
        Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 10, 2013 at 8:54 PM, Andy Shevchenko
<andy.shevchenko@gmail.com> wrote:
> Seems those inlines are leftovers from first versions of the driver. Anyway,
> looks fine by me. I think Viresh can give you an Ack.
>
> 9.5.2013 12.22 "Denis Efremov" <yefremov.denis@gmail.com> kirjoitti:
>>
>> EXPORT_SYMBOL and inline directives are contradictory to each other.
>> The patch fixes this inconsistency.
>>
>> Found by Linux Driver Verification project (linuxtesting.org).
>>
>> Signed-off-by: Denis Efremov <yefremov.denis@gmail.com>
>> ---
>>  drivers/dma/dw_dmac.c | 4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
