Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751572AbaEZEE0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 00:04:26 -0400
Received: from mail-oa0-f45.google.com ([209.85.219.45]:34061 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751534AbaEZEEZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 00:04:25 -0400
MIME-Version: 1.0
In-Reply-To: <20140524125946.GA31533@Nokia-N900>
References: <cover.1400736536.git.viresh.kumar@linaro.org>
	<c73c825beda0207867bd29e40fece217cbf15925.1400736536.git.viresh.kumar@linaro.org>
	<20140522145209.GA5246@developer>
	<CAKohpo=e62HPRF0N7kDvZEBAVPMFUeXVoL4jU--i7bZhn6Kjgw@mail.gmail.com>
	<20140524125946.GA31533@Nokia-N900>
Date: Mon, 26 May 2014 09:34:24 +0530
Message-ID: <CAKohpomN=e2ygpv_y+PXaPQM_7ULkQoKa0UrU5CN9Yeqtp3v_g@mail.gmail.com>
Subject: Re: [PATCH V3 1/8] cpufreq: cpufreq-cpu0: remove dependency on thermal
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: Eduardo Valentin <edubezval@gmail.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arvind Chauhan <arvind.chauhan@arm.com>,
        Ips Gandhi <inderpal.s@samsung.com>, Nishanth Menon <nm@ti.com>,
        Chander Kashyap <chander.kashyap@linaro.org>,
        "Brown, Len" <len.brown@intel.com>,
        Sudeep Holla <sudeep.holla@arm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24 May 2014 18:29, Pavel Machek <pavel@ucw.cz> wrote:
> On Fri 2014-05-23 10:03:27, Viresh Kumar wrote:
>> On 22 May 2014 20:22, Eduardo Valentin <edubezval@gmail.com> wrote:
>> > However, on CPUs that needs thermal managment, it makes sense to have
>> > such dependency, from functional perspective. Mainly because scaling
>> > frequency and voltage up would be allowed only when thermal management
>> > is enabled.
>>
>> AFAIK, dependencies in KCONFIG are only for fixing compilation time issues.
>
> I do not think that's correct.

Yeah, that what I accepted later as well.. Dependency is whatever without which
the module is unusable.

And cpufreq-cpu0 is usable without THERMAL and so this dependency should
go away..
