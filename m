Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751458AbaEZEBf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 00:01:35 -0400
Received: from mail-oa0-f49.google.com ([209.85.219.49]:36349 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750914AbaEZEBd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 00:01:33 -0400
MIME-Version: 1.0
In-Reply-To: <537F6F94.7040900@wwwdotorg.org>
References: <cover.1400662383.git.viresh.kumar@linaro.org>
	<59e1185a31e61c428aca9f4b8f0a69f182ee458e.1400662383.git.viresh.kumar@linaro.org>
	<537E27DA.9040709@wwwdotorg.org>
	<CAKohpokhiTpTd-ByFUuOL1hR7MnKPPQj-peH7S5oFxowKt0BeQ@mail.gmail.com>
	<537F6F94.7040900@wwwdotorg.org>
Date: Mon, 26 May 2014 09:31:32 +0530
Message-ID: <CAKohpomz5_Q=68QP7+-qbSrp-uSgSDD2ptmTnQdxASVO8jhDuw@mail.gmail.com>
Subject: Re: [PATCH V4 2/3] cpufreq: add support for intermediate (stable) frequencies
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arvind Chauhan <arvind.chauhan@arm.com>,
        Stephen Warren <swarren@nvidia.com>,
        Doug Anderson <dianders@chromium.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Peter De Schrijver <pdeschrijver@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23 May 2014 21:26, Stephen Warren <swarren@wwwdotorg.org> wrote:
> Oh OK, I guess the "notify" value is static then, and driver defined, so
> this is fine.

Correct!! Can you reply on the tegra patch also? So that we can close this
thread ASAP?
