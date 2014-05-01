Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751438AbaEASwc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 14:52:32 -0400
Received: from mail-vc0-f173.google.com ([209.85.220.173]:54775 "EHLO
	mail-vc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750929AbaEASw3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 14:52:29 -0400
MIME-Version: 1.0
In-Reply-To: <20140501184941.GV3245@sirena.org.uk>
References: <1397689950-1568-1-git-send-email-dianders@chromium.org>
	<1397689950-1568-5-git-send-email-dianders@chromium.org>
	<20140423115102.GO21613@lee--X1>
	<CAD=FV=WN4hVibiK_8+mpNfO7UQnd35ZT9EXA9fuw-mnBzzb1cA@mail.gmail.com>
	<CAOesGMiMiqk1mKcVF8SwePhUS-8cAmM3Ut3f+qRvjz27iw7CTA@mail.gmail.com>
	<20140501184941.GV3245@sirena.org.uk>
Date: Thu, 1 May 2014 11:52:28 -0700
X-Google-Sender-Auth: tdByy1zllVMdS4-zpAuf_VKToWo
Message-ID: <CAD=FV=W3qxMqM+cu-gEKkL4kNB-Jvo6-0tdt=L2madA8RLbfkw@mail.gmail.com>
Subject: Re: [PATCH v3 4/5] regulator: tps65090: Allow setting the overcurrent
 wait time
From: Doug Anderson <dianders@chromium.org>
To: Mark Brown <broonie@kernel.org>
Cc: Olof Johansson <olof@lixom.net>, Lee Jones <lee.jones@linaro.org>,
        Anton Vorontsov <anton@enomsg.org>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        AJAY KUMAR RAMAKRISHNA SHYMALAMMA <ajaykumar.rs@samsung.com>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Simon Glass <sjg@chromium.org>, Michael Spang <spang@chromium.org>,
        Sean Paul <seanpaul@chromium.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stephen Warren <swarren@wwwdotorg.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark,

On Thu, May 1, 2014 at 11:49 AM, Mark Brown <broonie@kernel.org> wrote:
> On Thu, May 01, 2014 at 11:17:58AM -0700, Olof Johansson wrote:
>
>> so it looks like tps_pdata is NULL. Should likely be a check for it?
>
> Yes, just about to post a fix.

Doh, was working on it at the same time.

https://patchwork.kernel.org/patch/4099981/

Sorry for the bug.  :(  Thanks for the report!

-Doug
