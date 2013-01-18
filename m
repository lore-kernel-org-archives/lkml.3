Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751374Ab3ARGe7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 01:34:59 -0500
Received: from mail-bk0-f49.google.com ([209.85.214.49]:49968 "EHLO
	mail-bk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750860Ab3ARGe5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 01:34:57 -0500
MIME-Version: 1.0
In-Reply-To: <003001cdf519$6d21c690$476553b0$@samsung.com>
References: <CAFp+6iE7zEJ7E_pRCOYz5mQqbk-MFE6Hwr02pRRT1yP+X3z7kQ@mail.gmail.com>
	<1358230225-2770-1-git-send-email-gautam.vivek@samsung.com>
	<003001cdf519$6d21c690$476553b0$@samsung.com>
Date: Fri, 18 Jan 2013 12:04:55 +0530
Message-ID: <CAFp+6iEmPg4G1hQfM1EKUBbXHKupF4mNh5v48jQWS5TyLV_Mow@mail.gmail.com>
Subject: Re: [PATCH v7] usb: phy: samsung: Add support to set pmu isolation
From: Vivek Gautam <gautamvivek1987@gmail.com>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: Vivek Gautam <gautam.vivek@samsung.com>, linux-usb@vger.kernel.org,
        l.majewski@samsung.com, linux-samsung-soc@vger.kernel.org,
        linux@arm.linux.org.uk, p.paneri@samsung.com,
        gregkh@linuxfoundation.org, devicetree-discuss@lists.ozlabs.org,
        broonie@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org,
        balbi@ti.com, kyungmin.park@samsung.com, cpgs@samsung.com,
        ben-linux@fluff.org, sylvester.nawrocki@gmail.com,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

HI Kukjin,

On Fri, Jan 18, 2013 at 6:46 AM, Kukjin Kim <kgene.kim@samsung.com> wrote:
> Vivek Gautam wrote:
>>
>> Adding support to parse device node data in order to get
>> required properties to set pmu isolation for usb-phy.
>>
>> Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
>> Reviewed-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
>> Reviewed-by: Doug Anderson <dianders@chromium.org>
>
> This looks good to me,
> Acked-by: Kukjin Kim <kgene.kim@samsung.com>
>
Thanks

> Vivek, could you please re-send following in one series?
> - [PATCH v9 1/2] usb: phy: samsung: Introducing usb phy driver for hsotg
> - [PATCH v8 2/2] usb: s3c-hsotg: Adding phy driver support
>

Praveen will re-send this patch-series asap.

> As I know, this should be applied on top of above patches.
>



-- 
Thanks & Regards
Vivek
