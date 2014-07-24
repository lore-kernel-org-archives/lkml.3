Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934169AbaGXFFB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 01:05:01 -0400
Received: from mail-oi0-f43.google.com ([209.85.218.43]:39964 "EHLO
	mail-oi0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934074AbaGXFE7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 01:04:59 -0400
MIME-Version: 1.0
In-Reply-To: <53D07737.70904@codeaurora.org>
References: <1404959850-11617-1-git-send-email-skannan@codeaurora.org>
	<16164926.ZsJxe6UV3e@vostro.rjw.lan>
	<53D07737.70904@codeaurora.org>
Date: Thu, 24 Jul 2014 10:34:58 +0530
Message-ID: <CAKohpokynnTttD7Wbq8uBB4SXK9xFEBdRJ2ozhMQscyvq69xRw@mail.gmail.com>
Subject: Re: [PATCH] cpufreq: Don't destroy/realloc policy/sysfs on hotplug/suspend
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Saravana Kannan <skannan@codeaurora.org>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Todd Poynor <toddpoynor@google.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24 July 2014 08:32, Saravana Kannan <skannan@codeaurora.org> wrote:
> Ok, I think I've figured this out. But one question. Is it possible to
> physically remove one CPU in a bunch of "related cpus" without also
> unplugging the rest? Put another way, can you unplug one core from a
> cluster?

Are we talking about doing this here:

echo 0 > /sys/devices/system/cpu/cpuX/online      ??

If yes, then what's the confusion all about? Yes we do it all the time.
