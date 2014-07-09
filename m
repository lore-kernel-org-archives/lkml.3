Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755053AbaGIDm0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 23:42:26 -0400
Received: from mail-lb0-f176.google.com ([209.85.217.176]:59065 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751513AbaGIDmY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 23:42:24 -0400
MIME-Version: 1.0
In-Reply-To: <53BC122C.9090505@samsung.com>
References: <1404118582-21993-1-git-send-email-sachin.kamat@samsung.com>
	<53BC122C.9090505@samsung.com>
Date: Wed, 9 Jul 2014 09:12:22 +0530
Message-ID: <CAK5sBcHJeK5=LrYfBO5C4Ht1upLes2ynvofuhBo3_xYsxGO1=g@mail.gmail.com>
Subject: Re: [PATCH 1/2] phy: Kconfig: Re-organize Exynos USB 2.0 PHY configs
From: Sachin Kamat <spk.linux@gmail.com>
To: Tomasz Figa <t.figa@samsung.com>
Cc: open list <linux-kernel@vger.kernel.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Doug Anderson <dianders@chromium.org>,
        Vivek Gautam <gautam.vivek@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tomasz,

On Tue, Jul 8, 2014 at 9:15 PM, Tomasz Figa <t.figa@samsung.com> wrote:
> On 30.06.2014 10:56, Sachin Kamat wrote:
>> Since the USB 2.0 PHYs are required only with EHCI/OHCI USB drivers,
>
> That's not true. They are also required for USB gadget controller
> supported by the DWC2 gadget driver (formerly s3c-hsotg). Otherwise the
> change makes sense to me.

Do you propose I amend just the patch description or also add a dependency on
USB_DWC2 along with EHCI and OHCI. I do not have anything to test this. Based
on your input I will re-spin the patch.

-- 
Regards,
Sachin.
