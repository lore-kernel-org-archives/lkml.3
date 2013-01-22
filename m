Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755310Ab3AVSpN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 13:45:13 -0500
Received: from mail-vb0-f52.google.com ([209.85.212.52]:37963 "EHLO
	mail-vb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753780Ab3AVSpK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 13:45:10 -0500
MIME-Version: 1.0
In-Reply-To: <02F0A27B-B16B-42F8-A0BC-29726732226D@dominion.thruhere.net>
References: <cover.1358871750.git.afzal@ti.com>
	<02F0A27B-B16B-42F8-A0BC-29726732226D@dominion.thruhere.net>
Date: Tue, 22 Jan 2013 12:45:09 -0600
Message-ID: <CAF6AEGuyb26EZ_9=GP9gs0TZqUtiFv3D_7+wcDOHuKn2qUcytQ@mail.gmail.com>
Subject: Re: [PATCH v3 00/12] video: da8xx-fb: am335x DT support
From: Rob Clark <robdclark@gmail.com>
To: Koen Kooi <koen@dominion.thruhere.net>
Cc: Afzal Mohammed <afzal@ti.com>, linux-fbdev@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Steffen Trumtrar <s.trumtrar@pengutronix.de>,
        Mike Turquette <mturquette@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 22, 2013 at 11:03 AM, Koen Kooi <koen@dominion.thruhere.net> wrote:
>
> Op 22 jan. 2013, om 17:51 heeft Afzal Mohammed <afzal@ti.com> het volgende geschreven:
>
>> Hi,
>>
>> This series adds DT support to da8xx-fb driver (device found on
>> DaVinci and AM335x SoC's). It does certain cleanup's in the process.
>>
>> This series as compared to previous version handles configuration of
>> the LCDC clock rate by modelling as a clock divider of CCF. This would
>> take effect only if CCF is selected, if not, no change to  existing
>> method.
>>
>> This makes use of Steffen Trumtrar's v16 of display timing DT support.
>
> Wouldn't it be better to delete da8xx-fb.* and switch to Rob Clarks DRM based driver for this IP block?

we probably can't delete da8xx-fb, but I think it would be ok to only
use it for legacy platforms not yet ported to DT.

BR,
-R

> regards,
>
> Koen--
> To unsubscribe from this list: send the line "unsubscribe linux-omap" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
