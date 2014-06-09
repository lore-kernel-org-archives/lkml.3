Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932152AbaFIUft (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 16:35:49 -0400
Received: from mail-qa0-f49.google.com ([209.85.216.49]:55997 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932143AbaFIUfr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 16:35:47 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.11.1406091617181.25775@knanqh.ubzr>
References: <1402090985-8061-1-git-send-email-dianders@chromium.org>
	<1402096465-13218-1-git-send-email-dianders@chromium.org>
	<7htx7uq7k1.fsf@paris.lan>
	<CAL1qeaGv+hBCr8oqs-E2j_Qh0Z=ZTVEaM-gdyu286Snu4otbMA@mail.gmail.com>
	<alpine.LFD.2.11.1406091617181.25775@knanqh.ubzr>
Date: Mon, 9 Jun 2014 13:35:46 -0700
Message-ID: <CAGa+x87puSoPftG6ddGTVtxOOxoUg_dLmMmZUHm-j6pjFuhr=g@mail.gmail.com>
Subject: Re: [PATCH v2] ARM: EXYNOS: mcpm: Don't rely on firmware's secondary_cpu_start
From: Kevin Hilman <khilman@linaro.org>
To: Nicolas Pitre <nicolas.pitre@linaro.org>
Cc: Andrew Bresticker <abrestic@chromium.org>,
        Doug Anderson <dianders@chromium.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Abhilash Kesavan <a.kesavan@samsung.com>,
        Inderpal Singh <inderpal.s@samsung.com>,
        Thomas Abraham <thomas.ab@samsung.com>,
        Olof Johansson <olof@lixom.net>, Tushar Behera <trblinux@gmail.com>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 9, 2014 at 1:22 PM, Nicolas Pitre <nicolas.pitre@linaro.org> wrote:
> On Mon, 9 Jun 2014, Andrew Bresticker wrote:
>
>> > [1] While waiting for the forth-coming patch from Andrew to enable the
>> >     CCI port for the boot cluster), I do this from u-boot before starting
>> >     the kernel (based on earlier email from Doug):
>> >
>> >     mw.l 10d25000 3  # Enable CCI from U-Boot
>>
>> From the other thread, it sounds like Nicolas wants enabling of the
>> boot cluster's CCI port to be done unconditionally for all MCPM
>> platforms.  Nicolas, are you preparing a patch for this or should I?
>
> I would like confirmation this indeed solves your problem first before I
> go ahead with it.

FYI... I confirmed on the other thread.  It works on the Chromebook2.

Kevin
