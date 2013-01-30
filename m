Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752357Ab3A3CLr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 21:11:47 -0500
Received: from mail-ob0-f178.google.com ([209.85.214.178]:50786 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751082Ab3A3CLp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 21:11:45 -0500
MIME-Version: 1.0
In-Reply-To: <1714110.knKZFeZSOf@vostro.rjw.lan>
References: <c7c9f237a91821661bfc0735e390358124953695.1359469932.git.viresh.kumar@linaro.org>
	<1714110.knKZFeZSOf@vostro.rjw.lan>
Date: Wed, 30 Jan 2013 07:41:44 +0530
Message-ID: <CAKohpo=wTEXDH+hHanRP4CjxPKVJs-oZSLA6_04XzpMLvOEdmA@mail.gmail.com>
Subject: Re: [PATCH V3] cpufreq: Simplify cpufreq_add_dev()
From: Viresh Kumar <viresh.kumar@linaro.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: inderpal.singh@linaro.org, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linaro-dev@lists.linaro.org, patches@linaro.org,
        robin.randhawa@arm.com, Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30 January 2013 03:15, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> Please don't add my sign-offs in advance.  Yes, I have signed off a *previous*
> version of that patch, but that doesn't apply to *this* version automatically.
>
> While you can do such things with Acked-by or Reviewed-by tags (that's not very
> polite, but people usually don't mind), sign-off is a bit different, because
> it is a *certificate* that this particular patch (and not some previous version
> of it) has gone through my hands.
>
> I'm going to apply this, but please be more careful in the future.

Its not that i have added it, but forgot to remove it. :(
I picked the patch from linux-next/master and forgot to remove your SOB.

--
viresh
