Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752691Ab3LPGO0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 01:14:26 -0500
Received: from mail-wg0-f43.google.com ([74.125.82.43]:38842 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752658Ab3LPGOX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 01:14:23 -0500
MIME-Version: 1.0
In-Reply-To: <52AE81B3.4010203@linaro.org>
References: <529F4B0F.2020801@linaro.org> <529F4B4F.4020405@linaro.org>
 <20131214235731.26321.53050@quantum> <52ADE93B.3070907@linaro.org>
 <E566434B-F630-4AD3-91EC-BD5599767F2E@linaro.org> <52AE81B3.4010203@linaro.org>
From: Mike Turquette <mturquette@linaro.org>
Date: Sun, 15 Dec 2013 22:14:02 -0800
Message-ID: <CAPtuhTi08LO7XfZa=7xArA2m2989FkTo4v+WRH+d_JmeKhvjuw@mail.gmail.com>
Subject: Re: [PATCH v2 2/3] clk: bcm281xx: add initial clock framework support
To: Alex Elder <alex.elder@linaro.org>
Cc: Christian Daudt <bcm@fixthebug.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Mark Rutland <mark.rutland@arm.com>, Pawel Moll <pawel.moll@arm.com>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Russell King <linux@arm.linux.org.uk>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Tim Kryger <tim.kryger@linaro.org>,
        "bcm-kernel-feedback-list@broadcom.com" 
	<bcm-kernel-feedback-list@broadcom.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 15, 2013 at 8:29 PM, Alex Elder <alex.elder@linaro.org> wrote:
> In the mean time, I have created a new branch that
> is based on v3.13-rc4 (and includes Tim's prerequisite
> patches).  Pull request (still wrapped my my mailer)
> is below.

Hi Alex,

This isn't a mess but is pretty normal. Can you create a new branch
with only your 2 clock patches applied on top of my clk-next branch?
You should merge "ARM: dts: bcm281xx: define real clocks" through the
arm-soc tree. Then you can send another pull request to me which has
just the 2 bcm clock patches based on clk-next and everything will
eventually end up linux-next all together.

Just FYI if I took your pull request as-is then the clk-next tree
would become polluted with lots of extra bcm patches.

Regards,
Mike
