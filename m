Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932397AbbAIKoc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 05:44:32 -0500
Received: from mail-ig0-f178.google.com ([209.85.213.178]:34844 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932403AbbAIKo2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 05:44:28 -0500
MIME-Version: 1.0
In-Reply-To: <1418719298-25314-4-git-send-email-tomeu.vizoso@collabora.com>
References: <1418719298-25314-1-git-send-email-tomeu.vizoso@collabora.com> <1418719298-25314-4-git-send-email-tomeu.vizoso@collabora.com>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Fri, 9 Jan 2015 19:44:07 +0900
Message-ID: <CAAVeFuK49SWCV3a3qKp2Mbo5GoMVQejuGwGFi-Ux4pXDFLi7cg@mail.gmail.com>
Subject: Re: [PATCH v5 3/3] ARM: tegra: Add Tegra124 ACTMON support
To: Tomeu Vizoso <tomeu.vizoso@collabora.com>
Cc: "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Mikko Perttunen <mikko.perttunen@kapsi.fi>,
        Arto Merilainen <amerilainen@nvidia.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 16, 2014 at 5:41 PM, Tomeu Vizoso
<tomeu.vizoso@collabora.com> wrote:
> Add device node for the ACTMON block to the Tegra124 device tree.

Reviewed-by: Alexandre Courbot <acourbot@nvidia.com>
