Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758989AbaD3ONt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 10:13:49 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:51505 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751602AbaD3ONs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 10:13:48 -0400
Message-ID: <1398867224.24255.22.camel@hornet>
Subject: Re: [PATCH 02/10] mfd: vexpress: Convert custom func API to regmap
From: Pawel Moll <pawel.moll@arm.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "arm@kernel.org" <arm@kernel.org>, Jean Delvare <jdelvare@suse.de>,
        Guenter Roeck <linux@roeck-us.net>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        Mike Turquette <mturquette@linaro.org>
Date: Wed, 30 Apr 2014 15:13:44 +0100
In-Reply-To: <20140430135855.GO29462@lee--X1>
References: <1398707877-22596-1-git-send-email-pawel.moll@arm.com>
	 <1398707877-22596-3-git-send-email-pawel.moll@arm.com>
	 <20140430135855.GO29462@lee--X1>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-04-30 at 14:58 +0100, Lee Jones wrote:
> MFD diffstat looks great and the changes look sensible:
>   Acked-by: Lee Jones <lee.jones@linaro.org>

Thanks!

> I guess someone will need to create a branch for us all to pull from.
> I'm happy to do it if needs be.

I was thinking that, with enough acks (and I'm counting on one from you
for "[PATCH 04/10] mfd: vexpress: Define the device as MFD cells" :-),
merging the whole series (or at least patches 1-4 and 7-8) through
arm-soc tree would be the simplest option. I have no problem with the
independent bits (clk, clocksource, hwmon and the mfd/HBI change) going
through appropriate subsystems.

Paweł

