Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755769AbaICITt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 04:19:49 -0400
Received: from mail-oa0-f43.google.com ([209.85.219.43]:47593 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751354AbaICITr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 04:19:47 -0400
MIME-Version: 1.0
In-Reply-To: <1409159852-7249-7-git-send-email-mathieu.poirier@linaro.org>
References: <1409159852-7249-1-git-send-email-mathieu.poirier@linaro.org>
	<1409159852-7249-7-git-send-email-mathieu.poirier@linaro.org>
Date: Wed, 3 Sep 2014 10:19:46 +0200
Message-ID: <CACRpkdb2PvkUOyVkhzk8WF457kZ5zqQVo5eFSMHk8u+mbNaZXQ@mail.gmail.com>
Subject: Re: [PATCH 06/11 v5] coresight-replicator: add CoreSight Replicator driver
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

> From: Pratik Patel <pratikp@codeaurora.org>
>
> This driver manages non-configurable CoreSight Replicator that
> takes a single input trace data stream and replicates it to
> produce two identical trace data output streams. Replicators
> are typically used to route single interleaved trace data
> stream to two or more sinks.
>
> Signed-off-by: Pratik Patel <pratikp@codeaurora.org>
> Signed-off-by: Panchaxari Prasannamurthy <panchaxari.prasannamurthy@linaro.org>
> Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>

Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
