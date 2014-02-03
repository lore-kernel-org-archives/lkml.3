Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753033AbaBCSzB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 13:55:01 -0500
Received: from hqemgate15.nvidia.com ([216.228.121.64]:10410 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752350AbaBCSzA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 13:55:00 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 03 Feb 2014 10:53:11 -0800
From: Andrew Chew <AChew@nvidia.com>
To: Daniel Lezcano <daniel.lezcano@linaro.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "thierry.reding@gmail.com" <thierry.reding@gmail.com>,
        "abrestic@chromium.org" <abrestic@chromium.org>,
        "dgreid@chromium.org" <dgreid@chromium.org>,
        "katierh@chromium.org" <katierh@chromium.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Date: Mon, 3 Feb 2014 10:54:58 -0800
Subject: RE: [PATCH v1] clocksource: tegra: Add nvidia,tegra30-timer compat
Thread-Topic: [PATCH v1] clocksource: tegra: Add nvidia,tegra30-timer compat
Thread-Index: Ac8g/qvGSMsyz1vGReuRTIkLNgJoRQAElPwQ
Message-ID: <643E69AA4436674C8F39DCC2C05F763863199852C7@HQMAIL03.nvidia.com>
References: <1391203779-5676-1-git-send-email-achew@nvidia.com>
 <52EFC652.9000209@linaro.org>
In-Reply-To: <52EFC652.9000209@linaro.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s13IthJP013029

> From: Daniel Lezcano [mailto:daniel.lezcano@linaro.org]
> Sent: Monday, February 03, 2014 8:40 AM
> To: Andrew Chew; tglx@linutronix.de; swarren@wwwdotorg.org;
> thierry.reding@gmail.com; abrestic@chromium.org; dgreid@chromium.org;
> katierh@chromium.org
> Cc: linux-kernel@vger.kernel.org; linux-tegra@vger.kernel.org
> Subject: Re: [PATCH v1] clocksource: tegra: Add nvidia,tegra30-timer compat
> 
> On 01/31/2014 10:29 PM, Andrew Chew wrote:
> > There are some differences between tegra20's timer registers and
> > tegra30's (and later).  For one thing, the watchdogs don't seem to be
> > present in tegra20.
> 
> "don't seem", so it is an assumption ?

No, this is not an assumption.  It has been verified by other NVIDIA engineers
since I proposed this change.

> > Add this compatibility string in order to be able to distinguish
> > whether the watchdogs are there or not.
> 
> Sorry but I don't get the connection between declaring the tegra30_timer
> and the log. Can you elaborate please ?

I don't know what you mean by "the log".  Was that a typo?  Anyway, I
have a watchdog driver that I intend to follow up with, that binds
with tegra30-timer.  I don't want this driver to be able to bind with
tegra20-timer, because the driver won't actually work on tegra20.

Does that answer your question?
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
