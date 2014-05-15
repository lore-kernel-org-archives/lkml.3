Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754942AbaEOSz6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 14:55:58 -0400
Received: from mail-ve0-f171.google.com ([209.85.128.171]:57504 "EHLO
	mail-ve0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751551AbaEOSz4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 14:55:56 -0400
MIME-Version: 1.0
In-Reply-To: <53750A9A.8000808@wwwdotorg.org>
References: <1397757570-19750-1-git-send-email-dianders@chromium.org>
	<1397757570-19750-8-git-send-email-dianders@chromium.org>
	<53750A9A.8000808@wwwdotorg.org>
Date: Thu, 15 May 2014 11:55:55 -0700
X-Google-Sender-Auth: Q3wExu_bD46JljyKtr8KdgA9dlU
Message-ID: <CAD=FV=Vj5M_yiYZOkjzB-QjYJa9WE2fcGcwwzAF1h8gcjc9jeA@mail.gmail.com>
Subject: Re: [PATCH 7/7] ARM: tegra: Add the EC i2c tunnel to tegra124-venice2
From: Doug Anderson <dianders@chromium.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Lee Jones <lee.jones@linaro.org>, Wolfram Sang <wsa@the-dreams.de>,
        Stephen Warren <swarren@nvidia.com>,
        Andrew Bresticker <abrestic@chromium.org>,
        Dylan Reid <dgreid@chromium.org>, Olof Johansson <olof@lixom.net>,
        Simon Glass <sjg@chromium.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Thierry Reding <thierry.reding@gmail.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen,

On Thu, May 15, 2014 at 11:42 AM, Stephen Warren <swarren@wwwdotorg.org> wrote:
> On 04/17/2014 11:59 AM, Doug Anderson wrote:
>> This adds the EC i2c tunnel (and devices under it) to the
>> tegra124-venice2 device tree.
>
> Did the MFD patches at the start of this series get applied yet? I was
> hoping to apply this one patch to the Tegra tree for 3.16, and that
> needs to happen by tomorrow morning at the latest since -rc6 is looming
> fast. However, I'm holding off until the rest of the series is applied
> to the MFD tree so I can be sure the DT binding is accepted first...

As far as I know, they didn't.  Lee was waiting on Wolfram's ack to
the i2c tunnel before landing them.  ...and I'm still eagerly awaiting
Wolfram's next i2c tunnel review.

-Doug
