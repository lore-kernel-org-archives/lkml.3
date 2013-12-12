Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751971Ab3LLV0w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 16:26:52 -0500
Received: from mail-ob0-f169.google.com ([209.85.214.169]:49256 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751734Ab3LLV0t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 16:26:49 -0500
MIME-Version: 1.0
In-Reply-To: <1386659456-16887-1-git-send-email-ldewangan@nvidia.com>
References: <1386659456-16887-1-git-send-email-ldewangan@nvidia.com>
Date: Thu, 12 Dec 2013 22:26:48 +0100
Message-ID: <CACRpkdbCkt3gm9YLW2B0=Ox4iw0Jdac1NrX0QcwwTL6uFCENZw@mail.gmail.com>
Subject: Re: [PATCH V3 1/2] pinctrl: tegra: Add devicetree binding document
 for Tegra124
From: Linus Walleij <linus.walleij@linaro.org>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>,
        Thierry Reding <thierry.reding@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 10, 2013 at 8:10 AM, Laxman Dewangan <ldewangan@nvidia.com> wrote:

> This device tree binding document describes the Tegra124 pincontrol
> DT bindings. This document lists all valid properties, names, mux
> options of Tegra124 pins.
>
> Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
> Acked-by: Stephen Warren <swarren@nvidia.com>
> ---
> Changes from V1:
> - Referred the dt-binding header file on describing the nodes.
>
> Changes from V2:
> - Rewording reg properties.
> - drop drv_type as it is not applicable.

Applied this v3 version, thanks!

Yours,
Linus Walleij
