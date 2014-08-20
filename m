Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753028AbaHTT3d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 15:29:33 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:59173 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751990AbaHTT3a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 15:29:30 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <CAD=FV=U9gOiY=4s7WmAQcm0n9s67nWdqQ3A0L2B7Dg83dNotjQ@mail.gmail.com>
References: <1408464476-28316-1-git-send-email-dianders@chromium.org> <1408464476-28316-3-git-send-email-dianders@chromium.org> <20140820100447.GG15414@ulmo> <CAD=FV=U9gOiY=4s7WmAQcm0n9s67nWdqQ3A0L2B7Dg83dNotjQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: [PATCH v3 2/4] pwm: rockchip: Allow polarity invert on rk3288
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Date: Wed, 20 Aug 2014 14:29:17 -0500
To: Doug Anderson <dianders@chromium.org>,
        Thierry Reding <thierry.reding@gmail.com>
CC: Heiko Stuebner <heiko@sntech.de>, Caesar Wang <caesar.wang@rock-chips.com>,
        Sonny Rao <sonnyrao@chromium.org>, Olof Johansson <olof@lixom.net>,
        Eddie Cai <eddie.cai@rock-chips.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        linux-pwm <linux-pwm@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        hpa@zytor.com
Message-ID: <387c82a0-efeb-431d-b8a5-200f24bc47ff@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On August 20, 2014 1:54:11 PM CDT, Doug Anderson <dianders@chromium.org> wrote:
>On Wed, Aug 20, 2014 at 3:04 AM, Thierry Reding
><thierry.reding@gmail.com> wrote:
>> On Tue, Aug 19, 2014 at 09:07:54AM -0700, Doug Anderson wrote:
>>> The rk3288 has the ability to invert 
>>> +     struct rockchip_pwm_chip *pc = to_rockchip_pwm_chip(chip);
>>> +
>>> +     if (!pc->data->has_invert)
>>> +             return -ENOSYS;
>>> +

At the kernel summit hpa also mentioned that ENOSYS should only be used for missing syscalls. Not sure what error code would suit better here though...


Thanks.

-- 
Dmitry
