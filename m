Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752157AbaFMN3v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 09:29:51 -0400
Received: from mail-qa0-f54.google.com ([209.85.216.54]:61458 "EHLO
	mail-qa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751295AbaFMN3s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 09:29:48 -0400
Date: Fri, 13 Jun 2014 09:29:46 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Chander Kashyap <k.chander@samsung.com>
cc: Kukjin Kim <kgene.kim@samsung.com>, Doug Anderson <dianders@chromium.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        Kevin Hilman <khilman@linaro.org>,
        Andrew Bresticker <abrestic@chromium.org>,
        Inderpal Singh <inderpal.s@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chander Kashyap <chander.kashyap@linaro.org>,
        "olof@lixom.net" <olof@lixom.net>, Tushar Behera <trblinux@gmail.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Thomas Abraham <thomas.ab@samsung.com>,
        Abhilash Kesavan <a.kesavan@samsung.com>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>
Subject: Re: [PATCH] ARM: EXYNOS: mcpm: Don't rely on firmware's
 secondary_cpu_start
In-Reply-To: <CADWw7Oh=A_cg_hqu8DZ1t_iacOGgWediLp3K3viFYHMNAPkqRw@mail.gmail.com>
Message-ID: <alpine.LFD.2.11.1406130922190.25775@knanqh.ubzr>
References: <1402090985-8061-1-git-send-email-dianders@chromium.org> <20140607181221.GB25068@e102568-lin.cambridge.arm.com> <CAD=FV=X17PeJ6JPE9Qyc1QT07AvA2PTE69Q87gz9a6MdUHgi4A@mail.gmail.com> <20140609223831.GB16889@e102568-lin.cambridge.arm.com>
 <CANuQgHHxAhTNYX-JAEdRkO=PMYT4A5GwXcuQfiqwE0CEkQyR+w@mail.gmail.com> <CAD=FV=V5_RRNkgA7Rk7XbQw9m1qh6-RJA8arW7ZRU=QbWAPa+w@mail.gmail.com> <alpine.LFD.2.11.1406101146140.25775@knanqh.ubzr> <CADWw7OjqK3MAuqCHuv-WS3Bb2+2Q-FXth+7hqtwFoyAP6pyYhA@mail.gmail.com>
 <CAD=FV=ULFx0GPp_mnEfouZF+m4h_RYE6WQu48N0WbFWrFv8-BA@mail.gmail.com> <5398758F.4080306@samsung.com> <CADWw7Oh=A_cg_hqu8DZ1t_iacOGgWediLp3K3viFYHMNAPkqRw@mail.gmail.com>
User-Agent: Alpine 2.11 (LFD 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Jun 2014, Chander Kashyap wrote:

> This patch is effectively changing the mcpm_entry_point address from
> nsbase + 0x1c to nsbase + 0x8
> 
> Hence while integrating with mainline u-boot we need to take care for
> new mcpm_entry_point address.

Why not inserting a NOP as the first instruction then? That way the 
offset will remain the same.


Nicolas
