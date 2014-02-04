Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932286AbaBDTOi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 14:14:38 -0500
Received: from hqemgate15.nvidia.com ([216.228.121.64]:2449 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751056AbaBDTOg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 14:14:36 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 04 Feb 2014 11:13:09 -0800
From: Andrew Chew <AChew@nvidia.com>
To: Thomas Gleixner <tglx@linutronix.de>
CC: Daniel Lezcano <daniel.lezcano@linaro.org>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "thierry.reding@gmail.com" <thierry.reding@gmail.com>,
        "abrestic@chromium.org" <abrestic@chromium.org>,
        "dgreid@chromium.org" <dgreid@chromium.org>,
        "katierh@chromium.org" <katierh@chromium.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Date: Tue, 4 Feb 2014 11:14:35 -0800
Subject: RE: [PATCH v1] clocksource: tegra: Add nvidia,tegra30-timer compat
Thread-Topic: [PATCH v1] clocksource: tegra: Add nvidia,tegra30-timer compat
Thread-Index: Ac8h3LUNsrWbOVLzS8e9oCErgSmhLgAAF5fw
Message-ID: <643E69AA4436674C8F39DCC2C05F76386319985620@HQMAIL03.nvidia.com>
References: <1391203779-5676-1-git-send-email-achew@nvidia.com>
 <52EFC652.9000209@linaro.org>
 <643E69AA4436674C8F39DCC2C05F763863199852C7@HQMAIL03.nvidia.com>
 <alpine.DEB.2.02.1402042004000.24986@ionos.tec.linutronix.de>
In-Reply-To: <alpine.DEB.2.02.1402042004000.24986@ionos.tec.linutronix.de>
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

> > > On 01/31/2014 10:29 PM, Andrew Chew wrote:
> > > > There are some differences between tegra20's timer registers and
> > > > tegra30's (and later).  For one thing, the watchdogs don't seem to
> > > > be present in tegra20.
> > >
> > > "don't seem", so it is an assumption ?
> >
> > No, this is not an assumption.  It has been verified by other NVIDIA
> > engineers since I proposed this change.
> 
> So why is your changelog saying "don't seem to be" ?

I updated the commit message (see V2 of this patch).  I hope the new
commit message satisfies the concerns:

"There are some differences between tegra20's timer registers and tegra30's
(and later).  For example, tegra30 has more timers.  In addition, watchdogs are
not present in tegra20.

Add this compatibility string in order to be able to distinguish whether the
additional timers and watchdogs are there or not."
