Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751497Ab3IQEiX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 00:38:23 -0400
Received: from mail-oa0-f51.google.com ([209.85.219.51]:42403 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751201Ab3IQEiV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 00:38:21 -0400
MIME-Version: 1.0
In-Reply-To: <7384008.XcFgntkLDk@vostro.rjw.lan>
References: <075032be4fd288074b8f699d4f4ba0179518df6f.1379344038.git.viresh.kumar@linaro.org>
	<1379348823.3422.42.camel@linaro1.home>
	<CAKohpomEQsS-WHQpa=_07NQ1FXDB711inrmMgUguD529BA7g1A@mail.gmail.com>
	<7384008.XcFgntkLDk@vostro.rjw.lan>
Date: Tue, 17 Sep 2013 10:08:20 +0530
Message-ID: <CAKohpondRF0NiYQW4vc1RXHaiqV3vCR9EHtZhM42AMW8xvm-+A@mail.gmail.com>
Subject: Re: [PATCH 1/2] cpufreq: unlock correct rwsem while updating policy->cpu
From: Viresh Kumar <viresh.kumar@linaro.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: "Jon Medhurst (Tixy)" <tixy@linaro.org>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Patch Tracking <patches@linaro.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17 September 2013 00:04, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> Care to resend with a subject indicating that that's a patch update?
>
> Like [PATCH v2] etc. or similar?

Yeah.. I was waiting for Tixy to test it once..
