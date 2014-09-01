Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754190AbaIAPaM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 11:30:12 -0400
Received: from mout.kundenserver.de ([212.227.17.24]:62958 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751665AbaIAPaJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 11:30:09 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Hanjun Guo <hanjun.guo@linaro.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Mark Rutland <mark.rutland@arm.com>, Olof Johansson <olof@lixom.net>,
        Grant Likely <grant.likely@linaro.org>,
        Graeme Gregory <graeme.gregory@linaro.org>,
        Sudeep Holla <Sudeep.Holla@arm.com>, Will Deacon <will.deacon@arm.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Mark Brown <broonie@kernel.org>, Rob Herring <robh@kernel.org>,
        Robert Richter <rric@kernel.org>, Lv Zheng <lv.zheng@intel.com>,
        Robert Moore <robert.moore@intel.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        Randy Dunlap <rdunlap@infradead.org>, Charles.Garcia-Tobin@arm.com,
        linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linaro-acpi@lists.linaro.org
Subject: Re: [RFC PATCH for Juno 0/2] Drivers for Juno to boot from ACPI
Date: Mon, 01 Sep 2014 17:29:05 +0200
Message-ID: <353732273.2TKdyNJ83M@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1409583961-7466-1-git-send-email-hanjun.guo@linaro.org>
References: <1409583961-7466-1-git-send-email-hanjun.guo@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:vJ9TFzG3yyVnDhsz230hvkwBiKPSY32dpnePPRS+D4l
 CqOOHj7035XU3er4VemJL+hT8CwiRehdEu3v23hKvh9hLMvI1G
 sHQyeDIpWYILDlXo0uWLyiqwusnXoRFOi8g+NEElev2mFgdBYl
 LQb4cC7XuWaHw2S1y4XdJvqfKmKqwbIJnw9IOI8EEANyt8dIfg
 /AvvpuUa8S5YzhxvWthkjX+T3nneVgHPwl+WGcZwUMINDbVFS8
 2iBvxEY5npa6ix97WkGBjMHm6EAx2pwahPi9btB7/e/zzakf1Y
 tWzXAqVAVRfSixKAHobeVMoeGkAnCBUrlt2u/Cg65a8pSOaNl9
 3QPyYS36g7OyAL4vy+qk=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 01 September 2014 23:05:59 Hanjun Guo wrote:
> This patch set is example of the sort of driver changes needed to boot
> Juno using ACPI tables, which using the ACPI tables devloped for MS
> Windows and published by ARM [1].

What about platform support?

I see that there is a patch in your git tree at
https://git.linaro.org/leg/acpi/acpi.git/commitdiff/b9a635e3b4cb167d399
that exposes the raw system registers in the same way that the DT support
does, which I guess is not how you plan to do it for ACPI when you are
done.

Is that still work in progress? How do you plan to abstract things
like the hwmon, LEDs, GPIO etc that are handled through the
sysregs in hardware?

	Arnd
