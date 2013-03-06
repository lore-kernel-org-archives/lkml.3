Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757009Ab3CFXJu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 18:09:50 -0500
Received: from mail-ob0-f179.google.com ([209.85.214.179]:63715 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753309Ab3CFXJs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 18:09:48 -0500
MIME-Version: 1.0
In-Reply-To: <20130306172517.GT17833@n2100.arm.linux.org.uk>
References: <f20e3c5e822c4bd28a3b71264d73143cc1f850b0.1362458878.git.viresh.kumar@linaro.org>
	<20130305105251.GL17833@n2100.arm.linux.org.uk>
	<CAKohponef2XNN2i8Dn7aBnzcdJeCmuGrmN3HjaBUZvBHkNSLKQ@mail.gmail.com>
	<20130306172517.GT17833@n2100.arm.linux.org.uk>
Date: Thu, 7 Mar 2013 07:09:47 +0800
Message-ID: <CAKohpo=CZFsj5jQ37rSNtb0A7jX3iZcTqShYwXbGCB=PSjJgeA@mail.gmail.com>
Subject: Re: [PATCH] cpufreq: ARM big LITTLE: Add generic cpufreq driver and
 its DT glue
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: rjw@sisk.pl, Steve.Bannister@arm.com, linux-pm@vger.kernel.org,
        Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>,
        Liviu.Dudau@arm.com, linux-kernel@vger.kernel.org,
        cpufreq@vger.kernel.org, robin.randhawa@arm.com,
        linux-arm-kernel@lists.infradead.org, mark.hambleton@broadcom.com,
        linaro-kernel@lists.linaro.org, charles.garcia-tobin@arm.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7 March 2013 01:25, Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:
> On Wed, Mar 06, 2013 at 12:38:36AM +0800, Viresh Kumar wrote:
>> So how does below fix look to you?
>
> Much better, but I think you want a better device name than just "clusterN".

I will try to find some other name, maybe cpu-cluster (as what you suggested
initially).

> Also, please get rid of that "default n" - n is the default default default
> default default default.... there's no need to specify it. :)

Ok :)
