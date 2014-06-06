Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752675AbaFFWqo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 18:46:44 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:49922 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752476AbaFFWqm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 18:46:42 -0400
MIME-Version: 1.0
In-Reply-To: <CAD=FV=U6cUNd4tZ1q3WUMkNpU-O-1yEbnEPuGkctwi_8UkBEkA@mail.gmail.com>
References: <1402090985-8061-1-git-send-email-dianders@chromium.org>
	<alpine.LFD.2.11.1406061831310.25775@knanqh.ubzr>
	<CAD=FV=U6cUNd4tZ1q3WUMkNpU-O-1yEbnEPuGkctwi_8UkBEkA@mail.gmail.com>
Date: Fri, 6 Jun 2014 15:46:41 -0700
X-Google-Sender-Auth: 7wMajYJZSyuMfYJ-NDeMvtR8mAY
Message-ID: <CAL1qeaFYqqDvYYhKMPwaP8TcyCtvr8afWi7GZN1E3d7ov6LJYA@mail.gmail.com>
Subject: Re: [PATCH] ARM: EXYNOS: mcpm: Don't rely on firmware's secondary_cpu_start
From: Andrew Bresticker <abrestic@chromium.org>
To: Doug Anderson <dianders@chromium.org>
Cc: Nicolas Pitre <nicolas.pitre@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Abhilash Kesavan <a.kesavan@samsung.com>,
        Inderpal Singh <inderpal.s@samsung.com>,
        Thomas Abraham <thomas.ab@samsung.com>,
        Olof Johansson <olof@lixom.net>, Tushar Behera <trblinux@gmail.com>,
        Kevin Hilman <khilman@linaro.org>,
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

>> If this is all that is needed to solve the problem being discussed in
>> the other thread I have absolutely no issue with such a workaround going
>> into mainline.
>
> This plus the CCI fix that Andrew is planning to post.

Right - we'll need a patch to enable the CCI port for the cluster we
booted on at boot and resume time since the first CPU up won't enter
through exynos_pm_power_up_setup().  I'll try to post something later
today or Monday.
