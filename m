Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752192AbaLQINu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 03:13:50 -0500
Received: from mail-ig0-f176.google.com ([209.85.213.176]:33574 "EHLO
	mail-ig0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752006AbaLQINq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 03:13:46 -0500
MIME-Version: 1.0
In-Reply-To: <1418397559-19646-1-git-send-email-digetx@gmail.com>
References: <1418397559-19646-1-git-send-email-digetx@gmail.com>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Wed, 17 Dec 2014 17:13:25 +0900
Message-ID: <CAAVeFuLPs8f1ZFT4JHTar1NRmb6rvYDv2i=pp-8LBwKEFw0sjA@mail.gmail.com>
Subject: Re: [PATCH] ARM: dts: tegra20: fix GR3D, DSI unit and reg base addresses
To: Dmitry Osipenko <digetx@gmail.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Stable <stable@vger.kernel.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 13, 2014 at 12:19 AM, Dmitry Osipenko <digetx@gmail.com> wrote:
> Commit 58ecb23f64ee ("ARM: tegra: add missing unit addresses to DT") added
> unit address and changed reg base for GR3D and DSI host1x modules, but these
> addresses belongs to GR2D and TVO modules respectively. Fix it by changing
> modules unit and reg base addresses to proper ones.

Checked with the TRM, you are absolutely correct.

Reviewed-by: Alexandre Courbot <acourbot@nvidia.com>
