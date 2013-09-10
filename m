Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752350Ab3IJVo7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 17:44:59 -0400
Received: from mail-vc0-f182.google.com ([209.85.220.182]:53616 "EHLO
	mail-vc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750977Ab3IJVo5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 17:44:57 -0400
MIME-Version: 1.0
In-Reply-To: <CA+bK7J4F=X97HUQP6Tt8RkVe5vttE_Sw4Pd7kT19k_KGDFfpKA@mail.gmail.com>
References: <CACxGe6v8hO4sRX_KGcH=YBAMrF8mQHqWdxXEvVwoC2pVS5Yv9Q@mail.gmail.com>
	<CA+bK7J5cAWFPLTBR2afNLm2JaKFH4_dJO_NpVL5gom0iX+L2dQ@mail.gmail.com>
	<CA+55aFzBbKXJnaG_6X8Fff_APGJ3EkbG0thsbithDXtiEJjdHA@mail.gmail.com>
	<CA+bK7J4F=X97HUQP6Tt8RkVe5vttE_Sw4Pd7kT19k_KGDFfpKA@mail.gmail.com>
Date: Tue, 10 Sep 2013 14:44:56 -0700
X-Google-Sender-Auth: YispQLInWqupyfRklsp8ex75hAY
Message-ID: <CA+55aFwkAQGRo9mLa2GVeVgzToRZr=Ny8LTogzgOpO6_4BJY1Q@mail.gmail.com>
Subject: Re: [GIT PULL] Device tree updates for v3.12
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Tim Bird <tbird20d@gmail.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Anton Blanchard <anton@samba.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 10, 2013 at 2:39 PM, Tim Bird <tbird20d@gmail.com> wrote:
>
> Well, I'm not sure how many bits of randomness this will add anyway.
> The way we're using device tree, we get the same values every boot, on
> all instances of the same phone model.  So this seems of little value.

If I recall correctly, somebody said that things like ethernet MAC
addresses etc sometimes come from DT. Is my memory going, or is that
true but very rare?

            Linus
