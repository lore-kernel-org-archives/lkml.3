Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755943AbaICInF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 04:43:05 -0400
Received: from mail-oi0-f53.google.com ([209.85.218.53]:49573 "EHLO
	mail-oi0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755616AbaICInB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 04:43:01 -0400
MIME-Version: 1.0
In-Reply-To: <1409159852-7249-9-git-send-email-mathieu.poirier@linaro.org>
References: <1409159852-7249-1-git-send-email-mathieu.poirier@linaro.org>
	<1409159852-7249-9-git-send-email-mathieu.poirier@linaro.org>
Date: Wed, 3 Sep 2014 10:43:00 +0200
Message-ID: <CACRpkdbD3Ds=iPxwD57ERd=xPAyVvdVbMEfjqdtAvO-0YqT_EA@mail.gmail.com>
Subject: Re: [PATCH 08/11 v5] coresight: adding documentation for coresight
From: Linus Walleij <linus.walleij@linaro.org>
To: Mathieu Poirier <mathieu.poirier@linaro.org>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Will Deacon <will.deacon@arm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Greg KH <gregkh@linuxfoundation.org>, Arnd Bergmann <arnd@linaro.org>,
        John Stultz <john.stultz@linaro.org>,
        Pratik Patel <pratikp@codeaurora.org>,
        Vikas Varshney <varshney@ti.com>, Al Grant <Al.Grant@arm.com>,
        Jonas Svennebring <jonas.svennebring@avagotech.com>,
        James King <james.king@linaro.org>,
        Panchaxari Prasannamurthy Tumkur 
	<panchaxari.prasannamurthy@linaro.org>,
        Kaixu Xia <kaixu.xia@linaro.org>,
        Marcin Jabrzyk <marcin.jabrzyk@gmail.com>, r.sengupta@samsung.com,
        Robert Marklund <robbelibobban@gmail.com>, Tony.Armitstead@arm.com,
        Patch Tracking <patches@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 27, 2014 at 7:17 PM,  <mathieu.poirier@linaro.org> wrote:

> From: Mathieu Poirier <mathieu.poirier@linaro.org>
>
> Documentation for the coresight framework and drivers.
>
> Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
(...)
>  Documentation/trace/coresight.txt | 237 ++++++++++++++++++++++++++++++++++++++

I guess you agreed on this location? If it's ARM-specific,
Documentation/arm/coresight.txt
is an alternative.

> +The file cstrace.bin can be decompressed using "ptm2human", DS-5 or Trace32.

Is ptm2human a candidate for the kernel tools/ directory?

Maybe not now but later?

+root@linaro-developer:/sys/kernel/debug/coresight# ls

Maybe reduce noise here:

root:/sys/kernel/debug/coresight# ls

The reader probably does not need to know the name of your
development system.

Yours,
Linus Walleij
