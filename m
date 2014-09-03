Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755583AbaICIRZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 04:17:25 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:37242 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751588AbaICIRX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 04:17:23 -0400
MIME-Version: 1.0
In-Reply-To: <1409159852-7249-5-git-send-email-mathieu.poirier@linaro.org>
References: <1409159852-7249-1-git-send-email-mathieu.poirier@linaro.org>
	<1409159852-7249-5-git-send-email-mathieu.poirier@linaro.org>
Date: Wed, 3 Sep 2014 10:17:23 +0200
Message-ID: <CACRpkdaR0KdkbGS8m+nUB8b=k3c_C0GNrWwzEfS+mzbZdRpahQ@mail.gmail.com>
Subject: Re: [PATCH 04/11 v5] coresight-etb: add CoreSight ETB driver
From: Linus Walleij <linus.walleij@linaro.org>
To: Mathieu Poirier <mathieu.poirier@linaro.org>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Will Deacon <will.deacon@arm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Greg KH <gregkh@linuxfoundation.org>, Arnd Bergmann <arnd@linaro.org>,
        Robert Marklund <robbelibobban@gmail.com>, Al Grant <Al.Grant@arm.com>,
        Patch Tracking <patches@linaro.org>,
        Marcin Jabrzyk <marcin.jabrzyk@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Panchaxari Prasannamurthy Tumkur 
	<panchaxari.prasannamurthy@linaro.org>,
        r.sengupta@samsung.com, Tony.Armitstead@arm.com,
        John Stultz <john.stultz@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        James King <james.king@linaro.org>,
        Pratik Patel <pratikp@codeaurora.org>,
        Vikas Varshney <varshney@ti.com>,
        Jonas Svennebring <jonas.svennebring@avagotech.com>,
        Kaixu Xia <kaixu.xia@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 27, 2014 at 7:17 PM,  <mathieu.poirier@linaro.org> wrote:

> From: Pratik Patel <pratikp@codeaurora.org>
>
> This driver manages CoreSight ETB (Embedded Trace Buffer) which
> acts as a circular buffer sink collecting generated trace data.
>
> Signed-off-by: Pratik Patel <pratikp@codeaurora.org>
> Signed-off-by: Panchaxari Prasannamurthy <panchaxari.prasannamurthy@linaro.org>
> Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>

Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
