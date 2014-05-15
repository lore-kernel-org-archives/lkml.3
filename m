Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752104AbaEOMOf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 08:14:35 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:50165 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751420AbaEOMOb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 08:14:31 -0400
MIME-Version: 1.0
In-Reply-To: <20140515074724.GJ16662@pengutronix.de>
References: <1400106655-22465-1-git-send-email-soren.brinkmann@xilinx.com>
	<20140515074724.GJ16662@pengutronix.de>
Date: Thu, 15 May 2014 07:14:30 -0500
X-Google-Sender-Auth: zqGUL_-Vp_uSTJ4cAvjUAg2xFdY
Message-ID: <CAGo_u6pxat1=X5tvqb8FYqUttYTaAimbjcdwsUYtS-rYt59v+A@mail.gmail.com>
Subject: Re: [RFC PATCH 0/5] Frequency resolution in CCF vs. cpufreq
From: Nishanth Menon <nm@ti.com>
To: =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: Soren Brinkmann <soren.brinkmann@xilinx.com>,
        Mike Turquette <mturquette@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        Michal Simek <michal.simek@xilinx.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 15, 2014 at 2:47 AM, Uwe Kleine-König
<u.kleine-koenig@pengutronix.de> wrote:
[...]
>> cpufreq, which simply divides values it obtains through clk_round_rate() by
>> 1000, 666666.
>> Since passing 666666 to clk_round_rate() does not result in 666666660
>> (clk_round_rate() always rounds down!), we chose to put 666667 in the OPP. This
> What is OPP?

Operating Performance Point (Documentation/power/opp.txt describes
frequencies in Hz, the bindings we chose in the community
Documentation/devicetree/bindings/power/opp.txt describes it in KHz).

Regards,
Nishanth Menon
