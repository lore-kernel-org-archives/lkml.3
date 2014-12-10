Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932093AbaLJNIE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 08:08:04 -0500
Received: from mail-la0-f46.google.com ([209.85.215.46]:34483 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755719AbaLJNID (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 08:08:03 -0500
MIME-Version: 1.0
In-Reply-To: <CAAVeFuKj1ekbGyn_bLVN9ndF=B=H=2HQXDzjEvhes=GCcVyv_A@mail.gmail.com>
References: <1418051276-5476-1-git-send-email-ricardo.ribalda@gmail.com>
 <1418051276-5476-3-git-send-email-ricardo.ribalda@gmail.com> <CAAVeFuKj1ekbGyn_bLVN9ndF=B=H=2HQXDzjEvhes=GCcVyv_A@mail.gmail.com>
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Date: Wed, 10 Dec 2014 14:07:40 +0100
Message-ID: <CAPybu_0Z5p1e6O4e3Qg+poJ2GwcHpd5wdnJ3EfPf9aN_VLX1ZA@mail.gmail.com>
Subject: Re: [PATCH 2/4] gpio/xilinx: Convert the driver to platform device interface
To: Alexandre Courbot <gnurou@gmail.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Michal Simek <michal.simek@xilinx.com>,
        =?UTF-8?Q?S=C3=B6ren_Brinkmann?= <soren.brinkmann@xilinx.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Alexandre

Will merge them and resend. May I add your acked by to the merged 2/3?

Thanks!

On Wed, Dec 10, 2014 at 11:49 AM, Alexandre Courbot <gnurou@gmail.com> wrote:
> On Tue, Dec 9, 2014 at 12:07 AM, Ricardo Ribalda Delgado
> <ricardo.ribalda@gmail.com> wrote:
>> This way we do not need to transverse the device tree manually and we
>> support hot plugged devices.
>
> Looks ok at first sight, but I think patch 3 should be merged into
> this one. They are really closely related.



-- 
Ricardo Ribalda
