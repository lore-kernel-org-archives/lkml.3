Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754821AbaDOSez (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 14:34:55 -0400
Received: from mail-wg0-f50.google.com ([74.125.82.50]:59747 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753244AbaDOSey (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 14:34:54 -0400
MIME-Version: 1.0
In-Reply-To: <CADHgK6sh6TUc4jBQFQHTQuhze9=r2FBzF6aULUc_c+bbWYjp5w@mail.gmail.com>
References: <1395348795-8554-1-git-send-email-sebastian.capella@linaro.org>
	<1395348795-8554-2-git-send-email-sebastian.capella@linaro.org>
	<20140320212336.GA17368@amd.pavel.ucw.cz>
	<20140320213502.795a5d3c@alan.etchedpixels.co.uk>
	<CADHgK6uXg0CXZC5s5Z5Kpy6dYH58UChL-p9ozCCcoUU=-0KJYw@mail.gmail.com>
	<CADHgK6sh6TUc4jBQFQHTQuhze9=r2FBzF6aULUc_c+bbWYjp5w@mail.gmail.com>
Date: Tue, 15 Apr 2014 11:34:52 -0700
Message-ID: <CADHgK6sCmPVZ--eyEnqnjfs_4C_PfHTgAUQ_Nb4oJP0mBDnQUw@mail.gmail.com>
Subject: Re: [PATCH RFC] PM / Hibernate: no kernel_power_off when pm_power_off NULL
From: Sebastian Capella <sebastian.capella@linaro.org>
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Cc: Pavel Machek <pavel@ucw.cz>, Linux Kernel <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        Len Brown <len.brown@intel.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Russell King <linux@arm.linux.org.uk>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ping..

There appears to be disagreement on the correct path to take on this.

Pavel and Alan recommend that arm's machine_power_off shall never return

Russell suggests hibernation be modified to handle machine_power_off
returning; that x86 architecture (and others as well) can have
machine_power_off returning.

Discussions available at the links below:
https://lkml.org/lkml/2014/3/25/554  -- linux-arm discussion
https://lkml.org/lkml/2014/3/20/649  -- linux-pm discussion

Should I continue with the original hibernation patch from the
linux-pm discussion?

Does anyone have any response to Russel's commentsl?

Thanks!

Sebastian
