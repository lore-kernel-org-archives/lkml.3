Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755938Ab3G3NtL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 09:49:11 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:43636 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755594Ab3G3NtI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 09:49:08 -0400
MIME-Version: 1.0
In-Reply-To: <1524530.dqCvbcsNq5@vostro.rjw.lan>
References: <2095cb9de80d87867dbfa42f8433f766891c93ab.1375191318.git.viresh.kumar@linaro.org>
	<1524530.dqCvbcsNq5@vostro.rjw.lan>
Date: Tue, 30 Jul 2013 19:19:07 +0530
Message-ID: <CAKohpok_Z943pkiyV3gFXpSpcp+gm724y3_P+fghwLRUOo-F6A@mail.gmail.com>
Subject: Re: [PATCH 1/2] cpufreq: Remove extra variables
From: Viresh Kumar <viresh.kumar@linaro.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30 July 2013 19:28, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Tuesday, July 30, 2013 07:06:33 PM Viresh Kumar wrote:
>> We call cpufreq_cpu_get() in cpufreq_add_dev_symlink() to increase usage
>> refcount of policy and not to get policy for a cpu. So, we don't really need to
>> capture the return value of this routine and call put for it later for failure
>> cases. We can simply use policy passed as an argument to this routine.
>>
>> Moreover debug print is rewritten to make it more clear.
>>
>> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
>
> Both [1-2/2] look good, but what do they apply to?  Mainline, linux-next,
> my bleeding-edge branch?

Sorry for not mentioning this, bleeding-edge :)
