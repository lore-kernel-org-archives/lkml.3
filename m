Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753829Ab3CNXCE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 19:02:04 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:58349 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753627Ab3CNXB5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 19:01:57 -0400
MIME-Version: 1.0
In-Reply-To: <CAFp+6iEV+C_nGtMhCUQX-M4T3Ac2i8QeAhkGC1wxrCBTAJrNYw@mail.gmail.com>
References: <1363195099-15919-1-git-send-email-dianders@chromium.org>
	<CAFp+6iEV+C_nGtMhCUQX-M4T3Ac2i8QeAhkGC1wxrCBTAJrNYw@mail.gmail.com>
Date: Thu, 14 Mar 2013 16:01:53 -0700
X-Google-Sender-Auth: KZ7pdbRrqiGPObjLzQHOCntrfOk
Message-ID: <CAD=FV=Xmtaag1DbvSV4jNVoy+XnSn0C2Xesaz+jJKR4k1DV=PQ@mail.gmail.com>
Subject: Re: [PATCH] ARM: dts: add usb 2.0 clock references to exynos5250
 device tree
From: Doug Anderson <dianders@chromium.org>
To: Vivek Gautam <gautamvivek1987@gmail.com>
Cc: Kukjin Kim <kgene.kim@samsung.com>, Olof Johansson <olof@lixom.net>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Vivek Gautam <gautam.vivek@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        Padmavathi Venna <padma.v@samsung.com>,
        Jingoo Han <jg1.han@samsung.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek,

On Wed, Mar 13, 2013 at 11:22 PM, Vivek Gautam
<gautamvivek1987@gmail.com> wrote:
> It will be nice if you can please update relevant information
> alongwith this, in the bindings doc for "exynos-usb".

Sure.  It always feels like device tree additions ought to be separate
patches from bindings patches, so I'll just send something separately.
 Here it is: <https://patchwork.kernel.org/patch/2274331/>

-Doug
