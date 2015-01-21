Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754127AbbAUGcd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 01:32:33 -0500
Received: from mail-ob0-f179.google.com ([209.85.214.179]:46777 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750786AbbAUGcb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 01:32:31 -0500
MIME-Version: 1.0
In-Reply-To: <54BF4369.1060900@samsung.com>
References: <1420681257-3078-1-git-send-email-cw00.choi@samsung.com>
	<1420681257-3078-3-git-send-email-cw00.choi@samsung.com>
	<CAL_Jsq+5sdsm_-VW-ta+qV-NBao-XTHvsYWcbMdZmbP0Nw43Cw@mail.gmail.com>
	<CAKohpomqosqxeDANC=NLBVmOUHyUoqd7Zhph7r6f7+ufYN48EQ@mail.gmail.com>
	<54BE108F.8090506@samsung.com>
	<CAKohpokSuVhH3hHFF+mLtJXvjt=bmJy1oZRBOttCNXORBS1Y0A@mail.gmail.com>
	<54BE3E10.2080906@samsung.com>
	<CAKohpontEntV48XqNcJq+euT9SdEjkgn5Pa=sSUpgM8mfKKCUA@mail.gmail.com>
	<54BF2929.3090107@samsung.com>
	<CAKohpomrAtqedODuzaAe3qO_YppeOU+LYR45eEs0+KcHJKHcQA@mail.gmail.com>
	<54BF4369.1060900@samsung.com>
Date: Wed, 21 Jan 2015 12:02:30 +0530
Message-ID: <CAKohponCbedTG2fqhUahw3mN_hK9YLpZnVXqxjHaV7UbkRKLYQ@mail.gmail.com>
Subject: Re: [PATCHv3 2/8] devfreq: exynos: Add documentation for generic
 exynos memory bus frequency driver
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Chanwoo Choi <cw00.choi@samsung.com>, Rob Herring <rob.herring@linaro.org>
Cc: Rob Herring <robherring2@gmail.com>,
        MyungJoo Ham <myungjoo.ham@samsung.com>, Kukjin Kim <kgene@kernel.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        Mark Rutland <mark.rutland@arm.com>, a.kesavan@samsung.com,
        Tomasz Figa <tomasz.figa@gmail.com>,
        =?UTF-8?Q?Krzysztof_Koz=C5=82owski?= <k.kozlowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Rob Herring <robh+dt@kernel.org>, InKi Dae <inki.dae@samsung.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21 January 2015 at 11:42, Chanwoo Choi <cw00.choi@samsung.com> wrote:
> OK, I understand.
> I'll try to update exynos memory bus according to your comment.

Great.

@Rob: So there is nothing special required for devfreq drivers in new
OPP bindings, right ? :)
