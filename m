Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754911AbaAIOqD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 09:46:03 -0500
Received: from mail-oa0-f47.google.com ([209.85.219.47]:59798 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751978AbaAIOp4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 09:45:56 -0500
MIME-Version: 1.0
In-Reply-To: <1645387.93uAkEaqro@vostro.rjw.lan>
References: <d9239e0a5df99392647ff8343673342f89d09476.1389059568.git.viresh.kumar@linaro.org>
	<CAOesGMgfFVoVJpOMXWtzVWj_F4pD-L9Osyv4u6=c8RUWOoLHFw@mail.gmail.com>
	<CAKohpo=EsaBPdF3wYsa2rEdjcpPagbhPcxWw1_PA=yVLDnjRiA@mail.gmail.com>
	<1645387.93uAkEaqro@vostro.rjw.lan>
Date: Thu, 9 Jan 2014 20:15:55 +0530
Message-ID: <CAKohpokTfpQFZM-QzLVBKZGRe66NxXpHmGwBzQKD+O3_pS_nsg@mail.gmail.com>
Subject: Re: [PATCH V3 Resend] cpufreq: create cpufreq_generic_get() routine
From: Viresh Kumar <viresh.kumar@linaro.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Olof Johansson <olof@lixom.net>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Fengguang Wu <fengguang.wu@intel.com>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        Patch Tracking <patches@linaro.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9 January 2014 17:41, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> Well, if build is broken, it *always* is the fault of the commit that
> introduced the breakage, even if that is a result of someone else doing
> things incorrectly.  Why?  Because it potentially breaks bisection for
> people and *that* is a big deal.

Agree :)

> So yes, I'm going to revert it.  Please resubmit after you've addressed the
> build breakage.

Will do that shortly.
