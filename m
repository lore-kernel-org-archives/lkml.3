Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754794AbaIBQxE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 12:53:04 -0400
Received: from mail-vc0-f182.google.com ([209.85.220.182]:54428 "EHLO
	mail-vc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754073AbaIBQxB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 12:53:01 -0400
MIME-Version: 1.0
In-Reply-To: <20140902163105.GY29327@sirena.org.uk>
References: <1409674469-12123-1-git-send-email-dianders@chromium.org>
	<1409674469-12123-3-git-send-email-dianders@chromium.org>
	<20140902163105.GY29327@sirena.org.uk>
Date: Tue, 2 Sep 2014 09:53:00 -0700
X-Google-Sender-Auth: lPCjXfb7qQy7DhsnX3oh9mt_rPA
Message-ID: <CAD=FV=Xnpqhqo4zQPJPUj3=BipeuD0+L4mxN_0zfJheTMnwjLA@mail.gmail.com>
Subject: Re: [PATCH 2/2] dt-bindings: Add input supplies to rk808 bindings
From: Doug Anderson <dianders@chromium.org>
To: Mark Brown <broonie@kernel.org>
Cc: Chris Zhong <zyw@rock-chips.com>, Sonny Rao <sonnyrao@chromium.org>,
        Heiko Stuebner <heiko@sntech.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-rockchip@lists.infradead.org, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        zhangqing <zhangqing@rock-chips.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark,

On Tue, Sep 2, 2014 at 9:31 AM, Mark Brown <broonie@kernel.org> wrote:
> On Tue, Sep 02, 2014 at 09:14:29AM -0700, Doug Anderson wrote:
>> The original bindings for rk808 didn't include input supplies.  Add
>> them.
>
> Acked-by: Mark Brown <broonie@linaro.org>
>
> You probably want to send this to Lee...

Good point.  I think it might actually be better for Chris to just
squash my bindings patch into his bindings patch since he still has to
send out another version.  If you haven't applied the regulator patch
by the time he sends his next version he can include my patch in his
series (with your Ack).

Chris did get an Ack for the MFD patch from Lee but I requested some
changes to the regulator patch.  When things look good Chris will add
you back to the CC list for the regulator part of his series.

Thanks!

-Doug
