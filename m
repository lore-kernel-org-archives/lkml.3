Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932997Ab3HGS1R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 14:27:17 -0400
Received: from mail-ob0-f177.google.com ([209.85.214.177]:46772 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932595Ab3HGS1P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 14:27:15 -0400
MIME-Version: 1.0
In-Reply-To: <51F2B384.9050706@wwwdotorg.org>
References: <1374833754-19659-1-git-send-email-ldewangan@nvidia.com>
	<1374833754-19659-2-git-send-email-ldewangan@nvidia.com>
	<51F2B384.9050706@wwwdotorg.org>
Date: Wed, 7 Aug 2013 20:27:14 +0200
Message-ID: <CACRpkdYXmccm-4dP4_cVCH-EPhhw9ww811Qu9ZVjZqN+e+8zVQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] pinctrl: pinconf_generic: add utility functions for
 add map/configs
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Laxman Dewangan <ldewangan@nvidia.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Graeme Gregory <gg@slimlogic.co.uk>, kishon@ti.com,
        Stephen Warren <swarren@nvidia.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 26, 2013 at 7:36 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:
> On 07/26/2013 04:15 AM, Laxman Dewangan wrote:
>> Some of pincontrol driver needs the utility function to create map
>> list. The utility function needed for adding mux, configs etc.

It is a noble goal to unify this and thank you *very* much for taking
it on.

> Which other drivers already contain this code? Are you planning on
> converting them over to use these new functions? The code looks
> familiar, so I assume it's just cut/paste from Tegra with some renames,
> so I didn't read it through in detail.
>
>>  drivers/pinctrl/pinconf-generic.c       |  105 +++++++++++++++++++++++++++++++
>>  include/linux/pinctrl/pinconf-generic.h |   52 +++++++++++++++
>
> I don't think those are the correct files for this code. Presumably
> there's no reason at all why a pinctrl driver that doesn't require
> CONFIG_GENERIC_PINCONF can't use these basic utility functions. Perhaps
> add a new pinctrl-utils file?

Agree with Stephen, we need to put this in a separate file, such at
pinctrl-dt.c or just put it into core.c.

Yours,
Linus Walleij
