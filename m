Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756654AbaDPU5p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 16:57:45 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:47190 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756582AbaDPU5n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 16:57:43 -0400
Date: Wed, 16 Apr 2014 21:57:18 +0100
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Sebastian Capella <sebastian.capella@linaro.org>,
        Pavel Machek <pavel@ucw.cz>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        Len Brown <len.brown@intel.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
Subject: Re: [PATCH RFC] PM / Hibernate: no kernel_power_off when
 pm_power_off NULL
Message-ID: <20140416215718.7f58efd8@alan.etchedpixels.co.uk>
In-Reply-To: <20140416204119.GJ24070@n2100.arm.linux.org.uk>
References: <1395348795-8554-1-git-send-email-sebastian.capella@linaro.org>
	<1395348795-8554-2-git-send-email-sebastian.capella@linaro.org>
	<20140320212336.GA17368@amd.pavel.ucw.cz>
	<20140320213502.795a5d3c@alan.etchedpixels.co.uk>
	<CADHgK6uXg0CXZC5s5Z5Kpy6dYH58UChL-p9ozCCcoUU=-0KJYw@mail.gmail.com>
	<CADHgK6sh6TUc4jBQFQHTQuhze9=r2FBzF6aULUc_c+bbWYjp5w@mail.gmail.com>
	<CADHgK6sCmPVZ--eyEnqnjfs_4C_PfHTgAUQ_Nb4oJP0mBDnQUw@mail.gmail.com>
	<20140415205453.GX24070@n2100.arm.linux.org.uk>
	<20140415211832.GA32213@amd.pavel.ucw.cz>
	<CADHgK6vzagyELYGnVoHvfnK9G57-NSycOaKsNQ53rnU1pOwn=Q@mail.gmail.com>
	<20140416204119.GJ24070@n2100.arm.linux.org.uk>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I'd say scrap (a) _unless_ we're going to add while (1) loops to all
> the architectures.  Alternatively, we could just accept that
> machine_power_off() may return and deal with that case (iow, not
> crash) in generic code.

What would the right behaviour be

while(1);

isn't really nice behaviour on a modern device 

 
