Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751361AbaBZGOI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 01:14:08 -0500
Received: from mail-ob0-f173.google.com ([209.85.214.173]:49391 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751157AbaBZGOG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 01:14:06 -0500
MIME-Version: 1.0
In-Reply-To: <1393385915-19138-3-git-send-email-skannan@codeaurora.org>
References: <1789244.B5CzWbcp6h@vostro.rjw.lan>
	<1393385915-19138-3-git-send-email-skannan@codeaurora.org>
Date: Wed, 26 Feb 2014 11:44:04 +0530
Message-ID: <CAKohpo=bmYX5iHrV7QixN_uFxB2jGDQYBbW23en0ZgeNesX6Aw@mail.gmail.com>
Subject: Re: [PATCH 3/3] cpufreq: Set policy to non-NULL only after all
 hotplug online work is done
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Saravana Kannan <skannan@codeaurora.org>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arm-msm@vger.kernel.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26 February 2014 09:08, Saravana Kannan <skannan@codeaurora.org> wrote:
> The existing code sets the per CPU policy to a non-NULL value before all
> the steps performed during the hotplug online path is done. Specifically,
> this is done before the policy min/max, governors, etc are initialized for
> the policy.  This in turn means that calls to cpufreq_cpu_get() return a
> non-NULL policy before the policy/CPU is ready to be used.

First two patches are fine but I would still say that take the three patches
I posted instead of this. Reasoning already given in other mails.
