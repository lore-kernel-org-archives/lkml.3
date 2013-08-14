Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760219Ab3HNSJl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 14:09:41 -0400
Received: from mail-ob0-f173.google.com ([209.85.214.173]:51310 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760196Ab3HNSJi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 14:09:38 -0400
MIME-Version: 1.0
In-Reply-To: <1375794755-6246-3-git-send-email-ldewangan@nvidia.com>
References: <1375794755-6246-1-git-send-email-ldewangan@nvidia.com>
	<1375794755-6246-3-git-send-email-ldewangan@nvidia.com>
Date: Wed, 14 Aug 2013 20:09:37 +0200
Message-ID: <CACRpkdZo9H-WmApXcDE0P_3eOdff5TWCK-NTSP=byMdTPzZjjg@mail.gmail.com>
Subject: Re: [PATCH V3 2/3] pinctrl: pinconf-generic: add generic APIs for
 mapping pinctrl node
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

> Add generic APIs to map the DT node and its sub node in pinconf generic
> driver. These APIs can be used from driver to parse the DT node who
> uses the pinconf generic APIs for defining their nodes.
>
> Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
> Reviewed-by: Stephen Warren <swarren@nvidia.com>
> ---
> Changes from V1:
> - Add generic property for pins and functions in pinconf-generic.
> - Add APIs to map the DT and subnode.
> - Move common utils APIs to the pinctrl-utils from this file.
> - Update the binding document accordingly.
> Changes from V2:
> - Rebased the pinctrl binding doc on top of Stephen's cleanup.
> - Rename properties "pinctrl-pins" and "pinctrl-function" to
>   "pins" and "function".

This v3 patch applied, dropping the three lines indicated by
Stephen to be added by another patch in my queue.

Yours,
Linus Walleij
