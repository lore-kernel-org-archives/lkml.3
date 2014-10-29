Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756447AbaJ2UGL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 16:06:11 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:37792 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751917AbaJ2UGJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 16:06:09 -0400
From: Kevin Hilman <khilman@kernel.org>
To: Chris Zhong <zyw@rock-chips.com>
Cc: heiko@sntech.de, dianders@chromium.org, mturquette@linaro.org,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Russell King <linux@arm.linux.org.uk>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-rockchip@lists.infradead.org, linux-gpio@vger.kernel.org,
        linux-kernel@vger.kernel.org, Kumar Gala <galak@codeaurora.org>,
        devicetree@vger.kernel.org, Tony Xie <xxx@rock-chips.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v6 0/7] This is the 1st version of suspend for RK3288.
References: <1414583525-17395-1-git-send-email-zyw@rock-chips.com>
Date: Wed, 29 Oct 2014 13:06:05 -0700
In-Reply-To: <1414583525-17395-1-git-send-email-zyw@rock-chips.com> (Chris
	Zhong's message of "Wed, 29 Oct 2014 19:51:58 +0800")
Message-ID: <7hppda7iaa.fsf@deeprootsystems.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chris,

Chris Zhong <zyw@rock-chips.com> writes:

> RK3288 can shut down the cpu, gpu and other device controllers in suspend,
> and it will pull the GLOBAL_PWROFF pin to high in the final stage of the
> process of suspend, pull the pin to low again when resume.

I tried to test this on top of linux-next (next-20141029) and it doesn't
wake up from serial port activity.

Can you describe how to test this, as well as describe dependencies on
other out-of-tree patches, including pointers to where they've been
posted.

Also, please describe how you tested this and on which hardware
platforms.  It's a big help to reviewers to know how it's been tested,
and for anyone with similar hardware to know what else it's been tested
on.

Thanks,

Kevin
