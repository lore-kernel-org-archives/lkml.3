Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757960Ab3C3Dgj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 23:36:39 -0400
Received: from mail-oa0-f51.google.com ([209.85.219.51]:60254 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757841Ab3C3Dgh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 23:36:37 -0400
MIME-Version: 1.0
In-Reply-To: <2566297.LngxUqUYMZ@vostro.rjw.lan>
References: <cover.1364398686.git.viresh.kumar@linaro.org>
	<2566297.LngxUqUYMZ@vostro.rjw.lan>
Date: Sat, 30 Mar 2013 09:06:37 +0530
Message-ID: <CAKohpon_C3LYe++cOb_9fgtz=DfQV_vWRNuH=UVXcKOO14GUhQ@mail.gmail.com>
Subject: Re: [PATCH V4 0/2] Implement per policy instance of governor
From: Viresh Kumar <viresh.kumar@linaro.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, arvind.chauhan@arm.com, robin.randhawa@arm.com,
        Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com, jacob.shin@amd.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30 March 2013 07:47, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Wednesday, March 27, 2013 09:28:56 PM Viresh Kumar wrote:

>> To test these over linux-next you need to revert following first:
>> db9baec cpufreq: Get rid of "struct global_attr"
>> 86bd6f0 cpufreq: governor: Implement per policy instances of governors
>> 8ae67b1 cpufreq: Add per policy governor-init/exit infrastructure

> I've applied these two patches and re-applied the queue on top of them.
>
> All is in my linux-next branch now.

You were supposed to remove below patch too, which you missed :)

c7baa5e cpufreq: Get rid of "struct global_attr"
