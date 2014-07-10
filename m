Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752415AbaGJI5V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 04:57:21 -0400
Received: from mail-oa0-f53.google.com ([209.85.219.53]:44448 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751539AbaGJI5R convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 04:57:17 -0400
MIME-Version: 1.0
In-Reply-To: <3adb614c-38ae-4b0c-9e50-99f071bbf4c5@BL2FFO11FD038.protection.gbl>
References: <1403091577-10232-1-git-send-email-harinik@xilinx.com>
	<5cc8b89b-20ff-4fa9-92dd-bb2f6d3512d8@BY2FFO11FD030.protection.gbl>
	<CACRpkdb1M3-hrSKLKWz21LCJ1sMvsq5E-aqkpmVhy0NwOS5HhA@mail.gmail.com>
	<d1af864d-bf78-48bb-a545-8de3f9def75f@BL2FFO11FD037.protection.gbl>
	<CACRpkdYSU6NdFuab6rJS7eADSqORNDBzbFfJ65nFoJj3EZVd-g@mail.gmail.com>
	<3adb614c-38ae-4b0c-9e50-99f071bbf4c5@BL2FFO11FD038.protection.gbl>
Date: Thu, 10 Jul 2014 10:57:16 +0200
Message-ID: <CACRpkdZb1jDh2_bAvjj5SPsG3k4Sr8nTEjiVR29dNx9rS5a0_g@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] gpio: Add driver for Zynq GPIO controller
From: Linus Walleij <linus.walleij@linaro.org>
To: =?UTF-8?Q?S=C3=B6ren_Brinkmann?= <soren.brinkmann@xilinx.com>
Cc: Harini Katakam <harini.katakam@xilinx.com>,
        Alexandre Courbot <gnurou@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        Michal Simek <michal.simek@xilinx.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Harini Katakam <harinikatakamlinux@gmail.com>,
        Harini Katakam <harinik@xilinx.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 8, 2014 at 5:55 PM, Sören Brinkmann
<soren.brinkmann@xilinx.com> wrote:

> I fully agree and you don't have to convince me. But to a lot of our
> customers that are used to use FPGAs, SOCs and Linux are pretty new. You
> see a lot of scary stuff. Accessing /dev/mem seems to be a lot of
> people's big hammer solution for everything. Then I always perceive it
> as great progress if things like the sysfs interface are used instead.

Well as upstream maintainer I really don't differentiate on the level
of badness of different bad solutions, none of them are really helpful
to the community, only to some specific user, so they get to carry the
quirks...

Yours,
Linus Walleij
