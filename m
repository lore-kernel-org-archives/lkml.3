Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752377AbaBKWLZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 17:11:25 -0500
Received: from hqemgate15.nvidia.com ([216.228.121.64]:12388 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751347AbaBKWLW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 17:11:22 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 11 Feb 2014 14:09:32 -0800
From: Andrew Chew <AChew@nvidia.com>
To: Guenter Roeck <linux@roeck-us.net>, "wim@iguana.be" <wim@iguana.be>,
        "rob@landley.net" <rob@landley.net>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "thierry.reding@gmail.com" <thierry.reding@gmail.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "abrestic@chromium.org" <abrestic@chromium.org>,
        "dgreid@chromium.org" <dgreid@chromium.org>,
        "katierh@chromium.org" <katierh@chromium.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-watchdog@vger.kernel.org" <linux-watchdog@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Date: Tue, 11 Feb 2014 14:11:20 -0800
Subject: RE: [PATCH v5 1/1] watchdog: Add tegra watchdog
Thread-Topic: [PATCH v5 1/1] watchdog: Add tegra watchdog
Thread-Index: Ac8jp/ik4+hKjovOQkutJBQS/7f+bgDziKrg
Message-ID: <643E69AA4436674C8F39DCC2C05F76386319AB352D@HQMAIL03.nvidia.com>
References: <1391738086-29142-1-git-send-email-achew@nvidia.com>
 <52F43D88.2050304@roeck-us.net>
In-Reply-To: <52F43D88.2050304@roeck-us.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On 02/06/2014 05:54 PM, Andrew Chew wrote:
> > Add a driver for the hardware watchdogs in NVIDIA Tegra SoCs (Tegra30
> > and later).  This driver will configure one watchdog timer that will
> > reset the system in the case of a watchdog timeout.
> >
> > This driver binds to the nvidia,tegra30-timer device node and gets its
> > register base from there.
> >
> > Signed-off-by: Andrew Chew <achew@nvidia.com>
> 
> Reviewed-by: Guenter Roeck <linux@roeck-us.net>

Thanks, Guenter.

Pinging other potential reviewers.  Any other comments for me, guys?
