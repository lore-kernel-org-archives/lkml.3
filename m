Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751628Ab3FCGzI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 02:55:08 -0400
Received: from mail-ob0-f177.google.com ([209.85.214.177]:55047 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750935Ab3FCGzD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 02:55:03 -0400
MIME-Version: 1.0
In-Reply-To: <CAKohpokGDFvtaBMKxLTJCkx_WN+HN4eZ7LZ2upBLsXAsmcq7kA@mail.gmail.com>
References: <51A7BFA6.3070800@semaphore.gr>
	<51A8D0C2.1080801@semaphore.gr>
	<CAKohpokmn-Rf-1w2aQHMMMkMbJqxokWXm5ye3DNuc-yzzk=7pQ@mail.gmail.com>
	<3146671.7pOpkCChrO@vostro.rjw.lan>
	<CAKohpokGDFvtaBMKxLTJCkx_WN+HN4eZ7LZ2upBLsXAsmcq7kA@mail.gmail.com>
Date: Mon, 3 Jun 2013 12:25:02 +0530
Message-ID: <CAKohpo=EyudEW+EX=b7=Wp-7ceqjVksDTwwSJf77_LNFaaNL3w@mail.gmail.com>
Subject: Re: [PATCH] cpufreq: ondemand: Change the calculation of target frequency
From: Viresh Kumar <viresh.kumar@linaro.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Stratos Karafotis <stratosk@semaphore.gr>, linux-kernel@vger.kernel.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sent half written mail.. sorry.. will continue from where I left.

On 3 June 2013 12:21, Viresh Kumar <viresh.kumar@linaro.org> wrote:

> So, obviously the calculations aren't the same..

Now, this is how I understood these two different variables:
- cpuinfo.max_freq: maximum frequency (in kHz) which is
supported by this CPU
- policy->max: Maximum frequency forced by user or governor

When somebody sets policy->max, he expects cpufreq core to
use the range between min and max as the slope cpufreq core
has and adjust its frequencies accordingly..

Don't know if I am right or wrong :(
