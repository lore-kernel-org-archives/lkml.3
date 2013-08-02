Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757514Ab3HBHQx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 03:16:53 -0400
Received: from mail-oa0-f51.google.com ([209.85.219.51]:47189 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755446Ab3HBHQu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 03:16:50 -0400
MIME-Version: 1.0
In-Reply-To: <51FB5B1F.7030602@linux.vnet.ibm.com>
References: <2362640.pUofnXyzOi@vostro.rjw.lan>
	<51FAC46D.1000703@linux.vnet.ibm.com>
	<1757496.qSuJuAun9Z@vostro.rjw.lan>
	<2298639.F0Qv2QqRnZ@vostro.rjw.lan>
	<CAKohponru8Z1fod43dVtAODmYuMTGX70+73b8wk4wuGN=Vuh-w@mail.gmail.com>
	<51FB568B.1040902@linux.vnet.ibm.com>
	<CAKohpon85sFMz=2e=gdJ43JtVW9StW44CgKmJSuDtOZyq5cb+g@mail.gmail.com>
	<51FB5B1F.7030602@linux.vnet.ibm.com>
Date: Fri, 2 Aug 2013 12:46:50 +0530
Message-ID: <CAKohpo=oJU03zjOPOHU_pVr7VdmGe09Z-2FVc0YRewVRcVO59w@mail.gmail.com>
Subject: Re: [Update][PATCH] cpufreq: Do not hold driver module references for
 additional policy CPUs
From: Viresh Kumar <viresh.kumar@linaro.org>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux PM list <linux-pm@vger.kernel.org>, cpufreq@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2 August 2013 12:39, Srivatsa S. Bhat
<srivatsa.bhat@linux.vnet.ibm.com> wrote:
> I guess you are printing it at an odd time, when the module
> is still running its init function. Perhaps the core kernel
> module infrastructure increments the refcount around that
> region temporarily?

If I think logically, that sounds correct. I haven't looked at the
implementation details though. But yes, I understood why
my refcount was incremented :)

Thanks.
