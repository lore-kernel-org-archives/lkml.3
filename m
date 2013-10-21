Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751597Ab3JUUXr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 16:23:47 -0400
Received: from mail-bk0-f52.google.com ([209.85.214.52]:40073 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751253Ab3JUUXq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 16:23:46 -0400
MIME-Version: 1.0
In-Reply-To: <1382363634-10870-2-git-send-email-pdeschrijver@nvidia.com>
References: <1382363634-10870-1-git-send-email-pdeschrijver@nvidia.com>
	<1382363634-10870-2-git-send-email-pdeschrijver@nvidia.com>
Date: Mon, 21 Oct 2013 13:23:43 -0700
X-Google-Sender-Auth: zqDOm_hwfd0k92F7dFeFrNtUS2o
Message-ID: <CAL1qeaG9RDMWdN0vxq4Q3NgNbci1xZXCXcPT1L8G7F_U25C17A@mail.gmail.com>
Subject: Re: [PATCH v6 01/15] ARM: tegra30: add missing CLK IDs
From: Andrew Bresticker <abrestic@chromium.org>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
Cc: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Hiroshi Doyu <hdoyu@nvidia.com>, devicetree@vger.kernel.org,
        linux-tegra@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

> The Tegra30 clock bindings lack few IDs for audio and clk_out muxes.
>
> Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>

For the entire series,

Reviewed-by: Andrew Bresticker <abrestic@chromium.org>
