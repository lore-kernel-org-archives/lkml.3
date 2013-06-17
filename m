Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752024Ab3FQPsk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 11:48:40 -0400
Received: from mail-la0-f49.google.com ([209.85.215.49]:62228 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751765Ab3FQPsi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 11:48:38 -0400
MIME-Version: 1.0
In-Reply-To: <51BF2D52.2040000@samsung.com>
References: <1371143144-31764-1-git-send-email-dianders@chromium.org>
	<1371421068-28743-1-git-send-email-dianders@chromium.org>
	<1371421068-28743-2-git-send-email-dianders@chromium.org>
	<51BF2D52.2040000@samsung.com>
Date: Mon, 17 Jun 2013 08:48:34 -0700
X-Google-Sender-Auth: lwZl6wXi1Y0ReAiOlQffGnQA3Wo
Message-ID: <CAD=FV=Wy5H0JzDTtwo4p6TCk186G0KOecB7Tk=t2s0_XwzO2nw@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] MAINTAINERS: Add exynos filename match to ARM/S5P
 EXYNOS ARM ARCHITECTURES
From: Doug Anderson <dianders@chromium.org>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Tomasz Figa <tomasz.figa@gmail.com>, Olof Johansson <olof@lixom.net>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Joe Perches <joe@perches.com>, Stephen Rothwell <sfr@canb.auug.org.au>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Cesar Eduardo Barros <cesarb@cesarb.net>,
        "David S. Miller" <davem@davemloft.net>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kukjin,

On Mon, Jun 17, 2013 at 8:37 AM, Kukjin Kim <kgene.kim@samsung.com> wrote:
> On 06/17/13 07:17, Doug Anderson wrote:
>>
>> This will help direct patches related to exynos to the
>> linux-samsung-soc mailing list for discussion.
>>
>> Suggested by Joe Perches.
>>
>> Signed-off-by: Doug Anderson<dianders@chromium.org>
>
>
> Acked-by: Kukjin Kim <kgene.kim@samsung.com>

I _think_ you can even apply this to your tree.  Looking at commits to
MAINTAINERS it looks individual maintainers just include this in their
trees, though I could be wrong.

-Doug
