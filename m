Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755846AbaGXJMU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 05:12:20 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:33619 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751509AbaGXJMO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 05:12:14 -0400
Message-ID: <ca2398ca40725bf3b1b258ab3707970e.squirrel@www.codeaurora.org>
In-Reply-To: <CAKohpokynnTttD7Wbq8uBB4SXK9xFEBdRJ2ozhMQscyvq69xRw@mail.gmail.com>
References: <1404959850-11617-1-git-send-email-skannan@codeaurora.org>
    <16164926.ZsJxe6UV3e@vostro.rjw.lan> <53D07737.70904@codeaurora.org>
    <CAKohpokynnTttD7Wbq8uBB4SXK9xFEBdRJ2ozhMQscyvq69xRw@mail.gmail.com>
Date: Thu, 24 Jul 2014 09:12:13 -0000
Subject: Re: [PATCH] cpufreq: Don't destroy/realloc policy/sysfs on
 hotplug/suspend
From: skannan@codeaurora.org
To: "Viresh Kumar" <viresh.kumar@linaro.org>
Cc: "Saravana Kannan" <skannan@codeaurora.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "Todd Poynor" <toddpoynor@google.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
User-Agent: SquirrelMail/1.4.22-4.el6
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Viresh Kumar wrote:
> On 24 July 2014 08:32, Saravana Kannan <skannan@codeaurora.org> wrote:
>> Ok, I think I've figured this out. But one question. Is it possible to
>> physically remove one CPU in a bunch of "related cpus" without also
>> unplugging the rest? Put another way, can you unplug one core from a
>> cluster?
>
> Are we talking about doing this here:
>
> echo 0 > /sys/devices/system/cpu/cpuX/online      ??
>
> If yes, then what's the confusion all about? Yes we do it all the time.
>

No. That's why I said physically remove.

-- 
The Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

