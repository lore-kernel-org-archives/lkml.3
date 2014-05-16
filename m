Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754592AbaEPGGu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 02:06:50 -0400
Received: from mail-oa0-f45.google.com ([209.85.219.45]:60805 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753873AbaEPGGt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 02:06:49 -0400
MIME-Version: 1.0
In-Reply-To: <53750B27.4020708@wwwdotorg.org>
References: <a38df05b91198f393b1c4b78f39110c6bece3627.1400133049.git.viresh.kumar@linaro.org>
	<53750B27.4020708@wwwdotorg.org>
Date: Fri, 16 May 2014 11:36:48 +0530
Message-ID: <CAKohponB_wiJZ9jq+JrJGxe7Y-447FpEjSZRZ+snXpxmOP=Erg@mail.gmail.com>
Subject: Re: [PATCH] cpufreq: Tegra: drop wrapper around tegra_update_cpu_speed()
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Stephen Warren <swarren@nvidia.com>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arvind Chauhan <arvind.chauhan@arm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16 May 2014 00:14, Stephen Warren <swarren@wwwdotorg.org> wrote:
> On 05/14/2014 11:51 PM, Viresh Kumar wrote:
>> Tegra has implemented an unnecessary wrapper over tegra_update_cpu_speed(), i.e.
>> tegra_target(), which wasn't doing anything apart of calling
>> tegra_update_cpu_speed(). Get rid of that and use tegra_target() directly.
>
> I think it used to do something until some refactoring happened? Anyway,

Yep..

> Acked-by: Stephen Warren <swarren@nvidia.com>
>
