Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751930AbaLRCMB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 21:12:01 -0500
Received: from mail-ob0-f181.google.com ([209.85.214.181]:35591 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751510AbaLRCL7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 21:11:59 -0500
MIME-Version: 1.0
In-Reply-To: <3741028.CtOSUWyiaT@dtor-glaptop>
References: <1418771379-24369-1-git-send-email-dtor@chromium.org>
	<1418771379-24369-4-git-send-email-dtor@chromium.org>
	<CAKohpok0UieH=Pi4nU2tKqV1_LH+3uzMDr0B8wsN61g1BnG4pg@mail.gmail.com>
	<3741028.CtOSUWyiaT@dtor-glaptop>
Date: Thu, 18 Dec 2014 07:41:59 +0530
Message-ID: <CAKohpok4tk+P=ku-NjKiaW_VNmA-CwOyE9O3SoWHFhzNEx=VTw@mail.gmail.com>
Subject: Re: [PATCH 3/4] PM / OPP: take RCU lock in dev_pm_opp_get_opp_count
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Dmitry Torokhov <dtor@chromium.org>
Cc: Paul McKenney <paulmck@linux.vnet.ibm.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Stefan Wahren <stefan.wahren@i2se.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Nishanth Menon <nm@ti.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17 December 2014 at 22:58, Dmitry Torokhov <dtor@chromium.org> wrote:
> FWIW the change is a stop-gap; I hope we'll get away from using
> dev_pm_opp_get_opp_count() in cpufreq drivers and then we can revert the
> change. I just did not want to touch cpufreq drivers unless necessary.

Yeah, all good now. No more questions :)
