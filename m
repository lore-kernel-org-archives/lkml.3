Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752871AbaJ0SQb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 14:16:31 -0400
Received: from mail-qg0-f43.google.com ([209.85.192.43]:39354 "EHLO
	mail-qg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751953AbaJ0SQ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 14:16:28 -0400
MIME-Version: 1.0
In-Reply-To: <20141027171655.GH2006@localhost>
References: <1414427215-14380-1-git-send-email-romain.perier@gmail.com>
	<20141027171655.GH2006@localhost>
Date: Mon, 27 Oct 2014 19:16:27 +0100
Message-ID: <CABgxDoKMPm1+Ue2pE2zwzz8t-xpQ4pBK2pVYm5rJMEFkErHEjQ@mail.gmail.com>
Subject: Re: [PATCH v1 01/10] of: Rename "poweroff-source" property to "system-power-controller"
From: Romain Perier <romain.perier@gmail.com>
To: Johan Hovold <johan@kernel.org>
Cc: =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>,
        devicetree <devicetree@vger.kernel.org>,
        Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@linaro.org>, robh <robh@kernel.org>,
        mark.rutland@arm.com, linux-pm@vger.kernel.org,
        Guenter Roeck <linux@roeck-us.net>, Lee Jones <lee.jones@linaro.org>,
        Felipe Balbi <balbi@ti.com>, robh+dt@kernel.org,
        "pawel.moll" <pawel.moll@arm.com>,
        "ijc+devicetree" <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Alexandre Courbot <gnurou@gmail.com>,
        linux-arm-kernel@lists.infradead.org,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-10-27 18:16 GMT+01:00 Johan Hovold <johan@kernel.org>:
> You probably don't want this to be inline.
>
Yeah this is what I thought, I agree, it's a bit big to be inline... I
will fix it, I just wait a bit to see what is decided for this
serie...
