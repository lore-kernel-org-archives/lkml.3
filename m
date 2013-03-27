Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753504Ab3C0SoJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 14:44:09 -0400
Received: from mail-la0-f47.google.com ([209.85.215.47]:56670 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752930Ab3C0SoG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 14:44:06 -0400
MIME-Version: 1.0
In-Reply-To: <CAHfPSqBfvCPCgEUNmCJowfjMrCMjzhOXLbzu9Bxq4iJD7SkMJg@mail.gmail.com>
References: <1363129994-10438-1-git-send-email-dianders@chromium.org>
	<1363207202-10858-1-git-send-email-dianders@chromium.org>
	<1363207202-10858-3-git-send-email-dianders@chromium.org>
	<CAHfPSqBfvCPCgEUNmCJowfjMrCMjzhOXLbzu9Bxq4iJD7SkMJg@mail.gmail.com>
Date: Wed, 27 Mar 2013 11:44:04 -0700
X-Google-Sender-Auth: TsDsjg_msAaxIr0O8cCVcUdQ7zM
Message-ID: <CAD=FV=X5Zn_PF2OxFVtQWbz2zeWc0maRLPxftq8Ggwwcht7ArA@mail.gmail.com>
Subject: Re: [PATCH v2 2/4] iio: adc: Add dt support for turning on the phy in exynos-adc
From: Doug Anderson <dianders@chromium.org>
To: Naveen Krishna Ch <naveenkrishna.ch@gmail.com>
Cc: Jonathan Cameron <jic23@kernel.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Naveen Krishna Chatradhi <ch.naveen@samsung.com>,
        Olof Johansson <olof@lixom.net>, Guenter Roeck <linux@roeck-us.net>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Jonathan Cameron <jic23@cam.ac.uk>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-iio <linux-iio@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Naveen,

On Wed, Mar 27, 2013 at 11:37 AM, Naveen Krishna Ch
<naveenkrishna.ch@gmail.com> wrote:
> On 13 March 2013 13:40, Doug Anderson <dianders@chromium.org> wrote:
>> Without this change the exynos adc controller needed to have its phy
>> enabled in some out-of-driver C code.  Add support for specifying the
>> phy enable register by listing it in the reg list.
>>
>> Signed-off-by: Doug Anderson <dianders@chromium.org>
>> ---
>> Changes in v2: None
> Reviewed-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
>
> Lars, any update on this patch set. This change is required.

This particular CL is already in linux-next.
https://git.kernel.org/cgit/linux/kernel/git/next/linux-next-history.git/commit/?id=bb916ebbeabd18f7dc3c661275d2c9d343f4fa85
