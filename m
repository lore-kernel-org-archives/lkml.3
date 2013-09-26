Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756119Ab3IZI2E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 04:28:04 -0400
Received: from mail-qa0-f52.google.com ([209.85.216.52]:60783 "EHLO
	mail-qa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751018Ab3IZI2B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 04:28:01 -0400
MIME-Version: 1.0
In-Reply-To: <5243EF7F.4000606@linaro.org>
References: <cover.1379779777.git.viresh.kumar@linaro.org>
	<acd1cc837f969a50582d2b25a73c5e247f40f843.1379779777.git.viresh.kumar@linaro.org>
	<524365FA.4090108@linaro.org>
	<CAKohpong15qzFg_sZVB77wVm4gu-4Se1E=eqvJOv96fgnyMXDA@mail.gmail.com>
	<5243EF7F.4000606@linaro.org>
Date: Thu, 26 Sep 2013 13:58:00 +0530
Message-ID: <CAKohpongU4GpoEp5-WQJwxSbVFgAyWWcRDWo2zD+C8CGNhWwYQ@mail.gmail.com>
Subject: Re: [PATCH 20/21] cpuidle: don't calculate time-diff if entered_state
 == 0
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Patch Tracking <patches@linaro.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26 September 2013 13:55, Daniel Lezcano <daniel.lezcano@linaro.org> wrote:
> Yes I agree, but why are you saying "If entered_state == 0, we don't need to
> ..." ?

Ahh.. that's a mistake.. s/==/< :)
