Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752148Ab3FZN6d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 09:58:33 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:62855 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751355Ab3FZN6b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 09:58:31 -0400
X-AuditID: cbfee61b-b7f8e6d00000524c-56-51caf38661bd
Date: Wed, 26 Jun 2013 15:58:23 +0200
From: Lukasz Majewski <l.majewski@samsung.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: "Rafael J. Wysocky" <rjw@sisk.pl>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Lukasz Majewski <l.majewski@majess.pl>,
        Andre Przywara <andre.przywara@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>
Subject: Re: [PATCH v2 3/3] cpufreq:exynos:Extend Exynos cpufreq driver to
 support boost framework
Message-id: <20130626155823.47eb36fb@amdc308.digital.local>
In-reply-to: <CAKohponJ5FyuKywCGz5j8GYomwqEJ0B-CvJybp+_eLjrsRkXDA@mail.gmail.com>
References: <1370502472-7249-1-git-send-email-l.majewski@samsung.com>
 <1370941408-29304-1-git-send-email-l.majewski@samsung.com>
 <1370941408-29304-4-git-send-email-l.majewski@samsung.com>
 <CAKohponJ5FyuKywCGz5j8GYomwqEJ0B-CvJybp+_eLjrsRkXDA@mail.gmail.com>
Organization: SPRC Poland
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrLLMWRmVeSWpSXmKPExsVy+t9jQd22z6cCDdZO47H483Y5q8XTph/s
	FvM+y1p0nn3CbNG74CqbxZtH3BaXd81hs/jce4TR4nbjCjaL/oW9TBYdR74xW2z86uHA43Hn
	2h42j3XT3jJ79G1ZxejxaHELo8fnTXIBrFFcNimpOZllqUX6dglcGdv3tDEVzGOrmPs+vIHx
	G0sXIyeHhICJxIRj35kgbDGJC/fWs3UxcnEICUxnlJi05Bg7hNPOJLFiezNYB4uAqsSUf73M
	IDabgJ7E57tPgbo5OEQEtCRe3kwFqWcWeMYs8fjLGlaQGmGBFImJx/czgti8AtYSD2YfBNvG
	KRAsMbFzERuILSTQxiSxcUkOiM0vICnR/u8HM8RFdhLnPm1gh+gVlPgx+R7YDcxAuzZva2KF
	sOUlNq95yzyBUXAWkrJZSMpmISlbwMi8ilE0tSC5oDgpPddIrzgxt7g0L10vOT93EyM4Up5J
	72Bc1WBxiFGAg1GJh1dh68lAIdbEsuLK3EOMEhzMSiK8b+afChTiTUmsrEotyo8vKs1JLT7E
	KM3BoiTOe7DVOlBIID2xJDU7NbUgtQgmy8TBKdXAOL/6qHWS+RIZOeHbi021ty/+cfGb2Dk2
	BZ7smszwiY/fzGWb6MohVbnNyG3J1nuBGfMM9f9KvNmp595z2ujphHWBHyuSd87+ZfrmdsLa
	44W+e3c9O62l8fTB7KOHPdcoiQneCN7ndF2ujElSYcPnHHfJVacMls6qi2Xd9U9r4pnfazxY
	fwiYf1NiKc5INNRiLipOBADbVV32kAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Jun 2013 16:35:32 +0530, Viresh Kumar wrote:
> On 11 June 2013 14:33, Lukasz Majewski <l.majewski@samsung.com> wrote:
> > The struct cpufreq_driver has been extended to embrace the
> > information related to boost support.
> >
> > When "boost_mode" device tree attribute is defined for a platform,
> > the low_level_boost pointer is filled with proper address. The
> > .low_level_boost field filled to NULL, indicates that boost is not
> > supported.
> 
> This patch is still few generations back :)

But this is v2 version of boost patches.

Please also review:
[PATCH v4 4/7]
[PATCH v4 5/7]
[PATCH v4 6/7]
[PATCH v4 7/7] - disable boost at thermal framework



-- 
Best regards,

Lukasz Majewski

Samsung R&D Institute Poland (SRPOL) | Linux Platform Group
