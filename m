Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751086Ab3DOM5r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 08:57:47 -0400
Received: from mail-we0-f182.google.com ([74.125.82.182]:41496 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750864Ab3DOM5q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 08:57:46 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH] rtc: palmas: add dt support
To: Laxman Dewangan <ldewangan@nvidia.com>, akpm@linux-foundation.org
Cc: a.zummo@towertech.it, rtc-linux@googlegroups.com,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        rob.herring@calxeda.com, linux-tegra@vger.kernel.org,
        swarren@nvidia.com, Laxman Dewangan <ldewangan@nvidia.com>
In-Reply-To: <1363876330-26003-1-git-send-email-ldewangan@nvidia.com>
References: <1363876330-26003-1-git-send-email-ldewangan@nvidia.com>
Date: Mon, 15 Apr 2013 13:57:41 +0100
Message-Id: <20130415125741.BFD023E0AA8@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Mar 2013 20:02:10 +0530, Laxman Dewangan <ldewangan@nvidia.com> wrote:
> Add of_device_id table for Palma RTC to be enable the
> driver from DT file.
> 
> The driver can be registered from DT file as:
> 	palmas: tps65913@58 {
> 		:::::::::::
> 		palmas_rtc {
> 			compatible = "ti,palmas-rtc";
> 			interrupt-parent = <&palmas>;
> 			interrupts = <8 0>;
> 		};
> 	};
> 
> Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>

Pretty trivial...

Acked-by: Grant Likely <grant.likely@secretlab.ca>

g.
