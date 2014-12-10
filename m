Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755466AbaLJNJz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 08:09:55 -0500
Received: from mail-ie0-f177.google.com ([209.85.223.177]:43261 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751927AbaLJNJx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 08:09:53 -0500
MIME-Version: 1.0
In-Reply-To: <CAPybu_0Z5p1e6O4e3Qg+poJ2GwcHpd5wdnJ3EfPf9aN_VLX1ZA@mail.gmail.com>
References: <1418051276-5476-1-git-send-email-ricardo.ribalda@gmail.com>
 <1418051276-5476-3-git-send-email-ricardo.ribalda@gmail.com>
 <CAAVeFuKj1ekbGyn_bLVN9ndF=B=H=2HQXDzjEvhes=GCcVyv_A@mail.gmail.com> <CAPybu_0Z5p1e6O4e3Qg+poJ2GwcHpd5wdnJ3EfPf9aN_VLX1ZA@mail.gmail.com>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Wed, 10 Dec 2014 22:09:32 +0900
Message-ID: <CAAVeFuLs8CsNqCKdcB6tgKmbzuFaVDMxduxsXbKmR=mK8+h0=Q@mail.gmail.com>
Subject: Re: [PATCH 2/4] gpio/xilinx: Convert the driver to platform device interface
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Michal Simek <michal.simek@xilinx.com>,
        =?UTF-8?Q?S=C3=B6ren_Brinkmann?= <soren.brinkmann@xilinx.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 10, 2014 at 10:07 PM, Ricardo Ribalda Delgado
<ricardo.ribalda@gmail.com> wrote:
> Hello Alexandre
>
> Will merge them and resend. May I add your acked by to the merged 2/3?

Not yet, I'd like to review the merged patch to get a good picture of
what it is doing.
