Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760225Ab3HNSPe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 14:15:34 -0400
Received: from mail-ob0-f171.google.com ([209.85.214.171]:51877 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758530Ab3HNSPb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 14:15:31 -0400
MIME-Version: 1.0
In-Reply-To: <1375794755-6246-4-git-send-email-ldewangan@nvidia.com>
References: <1375794755-6246-1-git-send-email-ldewangan@nvidia.com>
	<1375794755-6246-4-git-send-email-ldewangan@nvidia.com>
Date: Wed, 14 Aug 2013 20:15:31 +0200
Message-ID: <CACRpkdZwyswYGQ3+peg5nOFYxBmzGkzJ97r+GUnHM5Y-ygVm4Q@mail.gmail.com>
Subject: Re: [PATCH V3 3/3] pinctrl: palmas: add pincontrol driver
From: Linus Walleij <linus.walleij@linaro.org>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>, Rob Landley <rob@landley.net>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Mark Brown <broonie@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Graeme Gregory <gg@slimlogic.co.uk>, kishon@ti.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 6, 2013 at 3:12 PM, Laxman Dewangan <ldewangan@nvidia.com> wrote:

> TI Palmas series Power Management IC have multiple pins which can be
> configured for different functionality. This pins can be configured
> for different function. Also their properties like pull up/down,
> open drain enable/disable are configurable.
>
> Add support for pincontrol driver Palmas series device like TPS65913,
> TPS80036. The driver supports to be register from DT only.
>
> Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
> Acked-by: Lee Jones <lee.jones@linaro.org>
> ---
> Changes from V1:
> - Add generic property for pins and functions in pinconf-generic.
> - Add APIs to map the DT and subnode.
> - Move common utils APIs to the pinctrl-utils from this file.
> - Update the binding document accordingly.
> Changes from V2:
> - Add ack by Lee.
> - Correct the binding docs.

This v3 version applied with Stepgen's Reviewed-by.

Yours,
Linus Walleij
