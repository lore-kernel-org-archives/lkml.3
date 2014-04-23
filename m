Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751821AbaDWWUQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 18:20:16 -0400
Received: from mail-ob0-f181.google.com ([209.85.214.181]:55310 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751356AbaDWWUN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 18:20:13 -0400
MIME-Version: 1.0
In-Reply-To: <5357D8CC.3080501@codeaurora.org>
References: <1371555182-12418-1-git-send-email-mathias.nyman@linux.intel.com>
	<1371555182-12418-2-git-send-email-mathias.nyman@linux.intel.com>
	<CAOZdJXU2hN+9TE=XN55TZF_W-0hxHZmK5330i6hwrhOERKFetw@mail.gmail.com>
	<534B93BA.6020406@linux.intel.com>
	<534BFAAF.3070805@codeaurora.org>
	<534D0370.50108@linux.intel.com>
	<535005BA.1040405@codeaurora.org>
	<5357A80B.8030701@linux.intel.com>
	<5357ACF1.9070206@codeaurora.org>
	<20140423135915.GY30677@intel.com>
	<5357D8CC.3080501@codeaurora.org>
Date: Thu, 24 Apr 2014 00:20:12 +0200
Message-ID: <CACRpkdbk8okbzaZgD=BqeMSOvbEvYNViqamd9i=NAaAWW=T9sQ@mail.gmail.com>
Subject: Re: [PATCH v3 1/1] pinctrl: add Intel BayTrail GPIO/pinctrl support
From: Linus Walleij <linus.walleij@linaro.org>
To: Timur Tabi <timur@codeaurora.org>
Cc: "Westerberg, Mika" <mika.westerberg@intel.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        lkml <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 23, 2014 at 5:14 PM, Timur Tabi <timur@codeaurora.org> wrote:

> How are the pin muxes normally configured in ACPI?

VERY good question.

>  All of our GPIOs have a
> pinmux on them, and so if you want to use the pin for the non-default
> functionality, you need to configure the mux.  Isn't that supposed to happen
> with the through the pinctrl driver?  That is, when the kernel parses the
> ASL, and it seems a command to configure pin #3 to function #4, it calls the
> local pinctrl driver to do that?

Let's suspect this is true. That is how GPIO work after all is it not?

I guess the other option would be that all systems must come with a
tailored set-up written in ASL, specific for each board configuration.

Yours,
Linus Walleij
