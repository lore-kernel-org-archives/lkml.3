Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754900AbaDRVio (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 17:38:44 -0400
Received: from mail-we0-f170.google.com ([74.125.82.170]:55924 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754857AbaDRVig (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 17:38:36 -0400
MIME-Version: 1.0
In-Reply-To: <20140416210901.GK24070@n2100.arm.linux.org.uk>
References: <20140320212336.GA17368@amd.pavel.ucw.cz>
	<20140320213502.795a5d3c@alan.etchedpixels.co.uk>
	<CADHgK6uXg0CXZC5s5Z5Kpy6dYH58UChL-p9ozCCcoUU=-0KJYw@mail.gmail.com>
	<CADHgK6sh6TUc4jBQFQHTQuhze9=r2FBzF6aULUc_c+bbWYjp5w@mail.gmail.com>
	<CADHgK6sCmPVZ--eyEnqnjfs_4C_PfHTgAUQ_Nb4oJP0mBDnQUw@mail.gmail.com>
	<20140415205453.GX24070@n2100.arm.linux.org.uk>
	<20140415211832.GA32213@amd.pavel.ucw.cz>
	<CADHgK6vzagyELYGnVoHvfnK9G57-NSycOaKsNQ53rnU1pOwn=Q@mail.gmail.com>
	<20140416204119.GJ24070@n2100.arm.linux.org.uk>
	<20140416215718.7f58efd8@alan.etchedpixels.co.uk>
	<20140416210901.GK24070@n2100.arm.linux.org.uk>
Date: Fri, 18 Apr 2014 14:38:34 -0700
Message-ID: <CADHgK6urB0wHFzTXakGqT9GA91=E-rSwnDqY-4xcjQS8Sijs-Q@mail.gmail.com>
Subject: Re: [PATCH RFC] PM / Hibernate: no kernel_power_off when pm_power_off NULL
From: Sebastian Capella <sebastian.capella@linaro.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Pavel Machek <pavel@ucw.cz>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        Len Brown <len.brown@intel.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks Russell, Alan!

So we're OK with the current patch + replacing while(1) after
kernel_halt at the end of power_down in hibernate.c with a while (1)
cpu_relax()?

Any other changes needed?

If not, I'll send a follow up patch with just these.

Thanks!

Sebastian
