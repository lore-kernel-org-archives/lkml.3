Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756940Ab3IAG0N (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Sep 2013 02:26:13 -0400
Received: from mail-oa0-f51.google.com ([209.85.219.51]:59588 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752186Ab3IAG0M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Sep 2013 02:26:12 -0400
MIME-Version: 1.0
In-Reply-To: <085013f4e584e3fef97187bcb349c3fa76942e19.1378012620.git.viresh.kumar@linaro.org>
References: <085013f4e584e3fef97187bcb349c3fa76942e19.1378012620.git.viresh.kumar@linaro.org>
Date: Sun, 1 Sep 2013 11:56:09 +0530
Message-ID: <CAKohpomt4vAxHiCkiSzpX6UttMqox=Sc9Oqhgxw6YHtkJfghGQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] cpufreq: don't allow governor limits to be changed
 when it is disabled
From: Viresh Kumar <viresh.kumar@linaro.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>, Stephen Boyd <sboyd@codeaurora.org>
Cc: Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Patch Tracking <patches@linaro.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Viresh Kumar <viresh.kumar@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1 September 2013 10:56, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> Its better if we can get these in for 3.11, otherwise we need to get them in the
> stable tree..

They can't get into 3.11 due to two reasons..
- I haven't tested them over 3.11 but linux-next/master.
- Few more dependency patches might also be required for 3.11..

So get them into 3.12-rc1 if they look okay to you :)
