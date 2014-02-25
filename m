Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753253AbaBYOk5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 09:40:57 -0500
Received: from mail-oa0-f43.google.com ([209.85.219.43]:47080 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753131AbaBYOkz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 09:40:55 -0500
MIME-Version: 1.0
In-Reply-To: <15001517.xLHO8lGdWr@vostro.rjw.lan>
References: <1393225072-3997-1-git-send-email-skannan@codeaurora.org>
	<530BAA31.4050701@codeaurora.org>
	<CAKohpo=0CgzjCgKnDxUMcN6-CgbQ2ML=Tx-K8fS7=VJJYOD0eg@mail.gmail.com>
	<15001517.xLHO8lGdWr@vostro.rjw.lan>
Date: Tue, 25 Feb 2014 20:10:54 +0530
Message-ID: <CAKohponkjccKjc9xBQ3kCjdTMqFtKLCh1-mQXMS579+2_JmTCA@mail.gmail.com>
Subject: Re: [PATCH] cpufreq: Set policy to non-NULL only after all hotplug
 online work is done
From: Viresh Kumar <viresh.kumar@linaro.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Saravana Kannan <skannan@codeaurora.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arm-msm@vger.kernel.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25 February 2014 18:34, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> Well, that depends on what the current users expect it to look like initially.
> It should be initialized to the point in which all of them can handle it
> correctly.

Exactly.

> That's not going to work in at least some cases anyway, because for some types
> of HW we simply can't retrieve the current frequency in a non-racy way.

I agree. But this is all that we can guarantee here :)
