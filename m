Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752720AbaFFEib (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 00:38:31 -0400
Received: from mail-ob0-f179.google.com ([209.85.214.179]:46622 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751316AbaFFEi3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 00:38:29 -0400
MIME-Version: 1.0
In-Reply-To: <CAD=FV=UHWEv4WNYdDvvFZ_Ars6TB=YRWf298aKPSjECwjD6a6w@mail.gmail.com>
References: <cover.1401728994.git.viresh.kumar@linaro.org>
	<41e5e755638334388a14821a625b703a1f851185.1401728995.git.viresh.kumar@linaro.org>
	<CAD=FV=UHWEv4WNYdDvvFZ_Ars6TB=YRWf298aKPSjECwjD6a6w@mail.gmail.com>
Date: Fri, 6 Jun 2014 10:08:29 +0530
Message-ID: <CAKohpomSa8V=nGhpdbZtTpvgaR93SpnrFbWmk7uR_6PN11K6rQ@mail.gmail.com>
Subject: Re: [PATCH V5 2/2] cpufreq: Tegra: implement intermediate frequency callbacks
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Doug Anderson <dianders@chromium.org>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arvind Chauhan <arvind.chauhan@arm.com>,
        Stephen Warren <swarren@nvidia.com>,
        Russell King <linux@arm.linux.org.uk>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Peter De Schrijver <pdeschrijver@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6 June 2014 01:21, Doug Anderson <dianders@chromium.org> wrote:
> The "Though when target-freq is intermediate freq, we don't need to
> take this reference." makes me think that this function is actually
> called when target-freq is intermediate freq.  I don't think it is,
> right?

Yes, it isn't called for that combination.

> I don't think that's a huge deal, though and code wise this looks good to me.

I don't know either, let me send a patch for that and see what people think :)

> Reviewed-by: Doug Anderson <dianders@chromium.org>

Thanks.
