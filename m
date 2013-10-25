Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754347Ab3JYNzr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 09:55:47 -0400
Received: from mail-ob0-f182.google.com ([209.85.214.182]:41900 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753791Ab3JYNzp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 09:55:45 -0400
MIME-Version: 1.0
In-Reply-To: <14730355.7hm7UiW5IU@vostro.rjw.lan>
References: <cover.1382104514.git.viresh.kumar@linaro.org>
	<14730355.7hm7UiW5IU@vostro.rjw.lan>
Date: Fri, 25 Oct 2013 19:25:45 +0530
Message-ID: <CAKohpokJrj_ZbCPUw4ZpfOWgsDvqxLH9j41eQVC7V7Ny4xE8mA@mail.gmail.com>
Subject: Re: [PATCH V2 Resend 00/34] CPUFreq Cleanup Part III
From: Viresh Kumar <viresh.kumar@linaro.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Patch Tracking <patches@linaro.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25 October 2013 18:26, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> Having considered that a bit I think that I'd prefer one patch doing all of
> these changes in one go (and with all applicable ACKs collected), one of the
> reasons being that if it is necessary to revert that stuff, whatever the
> reason, it will be much easier to do that with just one commit than with
> 34 of them.

With a similar reason I think the probability is more that a revert might
be required for individual drivers as they may need to switch back to
->target() instead of ->target_index() and so keeping them separate
might be better.

In case we need to revert all patches due to some breakage, we can
always do that in a single commit if required.

What do you say?
