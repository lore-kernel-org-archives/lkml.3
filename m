Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933980AbaFQRIE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 13:08:04 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:59027 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933790AbaFQRIA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 13:08:00 -0400
From: Kevin Hilman <khilman@linaro.org>
To: Bjorn Andersson <bjorn.andersson@sonymobile.com>
Cc: Rob Herring <robh+dt@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Kumar Gala <galak@codeaurora.org>, Lee Jones <lee.jones@linaro.org>,
        Josh Cartwright <joshc@codeaurora.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-arm-msm@vger.kernel.org>, Paul Walmsley <paul@pwsan.com>
Subject: Re: [PATCH v3 0/3] Qualcomm Resource Power Manager driver
References: <1402944372-31901-1-git-send-email-bjorn.andersson@sonymobile.com>
Date: Tue, 17 Jun 2014 10:07:57 -0700
In-Reply-To: <1402944372-31901-1-git-send-email-bjorn.andersson@sonymobile.com>
	(Bjorn Andersson's message of "Mon, 16 Jun 2014 11:46:09 -0700")
Message-ID: <7hvbrzbh1u.fsf@paris.lan>
User-Agent: Gnus/5.130008 (Ma Gnus v0.8) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

+Paul Walmsley

Bjorn Andersson <bjorn.andersson@sonymobile.com> writes:

> This series adds a regulator driver for the Resource Power Manager found in
> Qualcomm 8660, 8960 and 8064 based devices.
>
> The RPM driver exposes resources to its child devices, that can be accessed to
> implement drivers for the regulators, clocks and bus frequency control that's
> owned by the RPM in these devices.
>
> Changes since v2:
>   - Fix copy-paste error in dt binding
>   - Correct incomplete move from mfd to soc
>   - Correct const mistake in regulator driver
>
> Changes since v1:
>   - Moved rpm driver to drivers/soc

I'm not sure I follow the motivation for having this under drivers/soc?

In fact, my (possibly incorrect) understanding of this Resource Power
Manager is that it's actually to manage communication/control of
resources that are actually handled off the SoC by a microcontroller.

I added Paul W. to Cc so he can correct me, but I think this is a ways
off from the goal of what drivers/soc was for.

Kevin
