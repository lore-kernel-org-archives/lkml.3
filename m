Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752132Ab3LLSWj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 13:22:39 -0500
Received: from mail-oa0-f42.google.com ([209.85.219.42]:55169 "EHLO
	mail-oa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751564Ab3LLSWh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 13:22:37 -0500
MIME-Version: 1.0
In-Reply-To: <1386585140-1137-1-git-send-email-ldewangan@nvidia.com>
References: <1386585140-1137-1-git-send-email-ldewangan@nvidia.com>
Date: Thu, 12 Dec 2013 19:22:36 +0100
Message-ID: <CACRpkdagtueyzxRqVDWT+x8Sfrf7qR83aYj8oQfrc7Q5qSCjHg@mail.gmail.com>
Subject: Re: [PATCH V2 1/2] pinctrl: tegra: Add devicetree binding document
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

On Mon, Dec 9, 2013 at 11:32 AM, Laxman Dewangan <ldewangan@nvidia.com> wrote:

> This device tree binding document describes the Tegra124 pincontrol
> DT bindings. This document lists all valid properties, names, mux
> options of Tegra124 pins.
>
> Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
> ---
> Changes from V1:
> - Referred the dt-binding header file on describing the nodes.

I couldn't quite figure out if this is still under discussion or
not, I'm holding this off until I have an explicit ACK from
one of the DT binding people.

Yours,
Linus Walleij
