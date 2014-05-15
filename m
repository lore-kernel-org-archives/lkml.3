Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755553AbaEOUMr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 16:12:47 -0400
Received: from mail-qg0-f47.google.com ([209.85.192.47]:52841 "EHLO
	mail-qg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752514AbaEOUMp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 16:12:45 -0400
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:157d:b0d9:6664:26b8:883e]
In-Reply-To: <CAD=FV=Vj5M_yiYZOkjzB-QjYJa9WE2fcGcwwzAF1h8gcjc9jeA@mail.gmail.com>
References: <1397757570-19750-1-git-send-email-dianders@chromium.org>
	<1397757570-19750-8-git-send-email-dianders@chromium.org>
	<53750A9A.8000808@wwwdotorg.org>
	<CAD=FV=Vj5M_yiYZOkjzB-QjYJa9WE2fcGcwwzAF1h8gcjc9jeA@mail.gmail.com>
Date: Thu, 15 May 2014 13:12:44 -0700
Message-ID: <CAOesGMhe-STC3GUwAyC6qeEPWWmxdsWbXqdevy8b4MHDgM2v=A@mail.gmail.com>
Subject: Re: [PATCH 7/7] ARM: tegra: Add the EC i2c tunnel to tegra124-venice2
From: Olof Johansson <olof@lixom.net>
To: Doug Anderson <dianders@chromium.org>
Cc: Stephen Warren <swarren@wwwdotorg.org>, Lee Jones <lee.jones@linaro.org>,
        Wolfram Sang <wsa@the-dreams.de>, Stephen Warren <swarren@nvidia.com>,
        Andrew Bresticker <abrestic@chromium.org>,
        Dylan Reid <dgreid@chromium.org>, Simon Glass <sjg@chromium.org>,
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

On Thu, May 15, 2014 at 11:55 AM, Doug Anderson <dianders@chromium.org> wrote:
> Stephen,
>
> On Thu, May 15, 2014 at 11:42 AM, Stephen Warren <swarren@wwwdotorg.org> wrote:
>> On 04/17/2014 11:59 AM, Doug Anderson wrote:
>>> This adds the EC i2c tunnel (and devices under it) to the
>>> tegra124-venice2 device tree.
>>
>> Did the MFD patches at the start of this series get applied yet? I was
>> hoping to apply this one patch to the Tegra tree for 3.16, and that
>> needs to happen by tomorrow morning at the latest since -rc6 is looming
>> fast. However, I'm holding off until the rest of the series is applied
>> to the MFD tree so I can be sure the DT binding is accepted first...
>
> As far as I know, they didn't.  Lee was waiting on Wolfram's ack to
> the i2c tunnel before landing them.  ...and I'm still eagerly awaiting
> Wolfram's next i2c tunnel review.

The i2c portion can be revisited if needed, the MFD piece should be
possible to land sooner than that... Lee?


-Olof
