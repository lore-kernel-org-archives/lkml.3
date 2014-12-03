Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751463AbaLCIsZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 03:48:25 -0500
Received: from mail-qg0-f47.google.com ([209.85.192.47]:46707 "EHLO
	mail-qg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751099AbaLCIsX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 03:48:23 -0500
Date: Wed, 3 Dec 2014 08:48:15 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Bryan Wu <cooloney@gmail.com>
Cc: gyungoh@gmail.com, Samuel Ortiz <sameo@linux.intel.com>,
        Jingoo Han <jg1.han@samsung.com>, Mark Brown <broonie@kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>, jack.yoo@skyworksinc.com,
        lkml <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Pawel Moll <pawel.moll@arm.com>,
        heiko@sntech.de, Jason Cooper <jason@lakedaemon.net>,
        Thierry Reding <treding@nvidia.com>, florian.vaussard@epfl.ch,
        Jiri Kosina <trivial@kernel.org>, Guenter Roeck <linux@roeck-us.net>,
        Andrew Lunn <andrew@lunn.ch>, jic23@kernel.org
Subject: Re: [PATCH v9 2/8] backlight: Add support Skyworks SKY81452
 backlight driver
Message-ID: <20141203084815.GF22522@x1>
References: <1417507529-13654-1-git-send-email-jack.yoo@skyworksinc.com>
 <1417507529-13654-3-git-send-email-jack.yoo@skyworksinc.com>
 <CAK5ve-+zYtdf2fo=xqAZaR6vcrOQRSicZC+2AX0qHNqmBhoDTg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAK5ve-+zYtdf2fo=xqAZaR6vcrOQRSicZC+2AX0qHNqmBhoDTg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 02 Dec 2014, Bryan Wu wrote:

> On Tue, Dec 2, 2014 at 12:05 AM,  <gyungoh@gmail.com> wrote:
> > From: Gyungoh Yoo <jack.yoo@skyworksinc.com>
> >
> > Signed-off-by: Gyungoh Yoo <jack.yoo@skyworksinc.com>
> 
> This patch looks good to me and I think Jingoo reviewed it already. So
> please take my Ack here:
> Acked-by: Bryan Wu <cooloney@gmail.com>
> 
> Lee, can you apply this patch?

I can, but we need to see what's happening with the other patches in
the set first.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
