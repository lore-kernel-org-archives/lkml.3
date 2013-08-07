Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933038Ab3HGSIH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 14:08:07 -0400
Received: from mail-oa0-f44.google.com ([209.85.219.44]:56909 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932945Ab3HGSIF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 14:08:05 -0400
MIME-Version: 1.0
In-Reply-To: <52028745.6080707@wwwdotorg.org>
References: <cover.1375886595.git.viresh.kumar@linaro.org>
	<bfa34bd91e0fa4c6e215517e10c93ab271486418.1375886595.git.viresh.kumar@linaro.org>
	<52028745.6080707@wwwdotorg.org>
Date: Wed, 7 Aug 2013 23:38:03 +0530
Message-ID: <CAKohponrGLbx11f7rvamxaSme2XhgPuMDuOOmVgsmhMsTtN2Tw@mail.gmail.com>
Subject: Re: [PATCH 3/6] ARM: Tegra: Enable OPP library
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: rjw@sisk.pl, swarren@nvidia.com, linaro-kernel@lists.linaro.org,
        patches@linaro.org, cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, mturquette@linaro.org,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7 August 2013 23:13, Stephen Warren <swarren@wwwdotorg.org> wrote:
> On 08/07/2013 08:46 AM, Viresh Kumar wrote:
>> cpufreq-cpu0 driver is dependent on OPP library and hence we need to enable it
>> for Tegra as we are going to use cpufreq-cpu0.
>
> Shouldn't these be selected by something in drivers/cpufreq/Kconfig?

There is nothing tegra specific in that directory now and so probably
this is the best place :)

Creating a config option only for this doesn't sound great to me..
