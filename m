Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751994Ab3FZOCt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 10:02:49 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:63185 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751498Ab3FZOCr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 10:02:47 -0400
X-AuditID: cbfee61a-b7f3b6d000006edd-8f-51caf485bd85
Date: Wed, 26 Jun 2013 16:02:37 +0200
From: Lukasz Majewski <l.majewski@samsung.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Lukasz Majewski <l.majewski@samsung.com>,
        "Rafael J. Wysocky" <rjw@sisk.pl>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Lukasz Majewski <l.majewski@majess.pl>,
        Andre Przywara <andre.przywara@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>, Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>, t.figa@samsung.com
Subject: Re: [PATCH v4 2/7] cpufreq: Add boost frequency support in core
Message-id: <20130626160237.659f9b1d@amdc308.digital.local>
In-reply-to: <20130626145412.1e9bfa63@amdc308.digital.local>
References: <1370502472-7249-1-git-send-email-l.majewski@samsung.com>
 <1371661969-7660-1-git-send-email-l.majewski@samsung.com>
 <1371661969-7660-3-git-send-email-l.majewski@samsung.com>
 <CAKohpon7GLGvrkFQdWpco5f9P7S8L-2-ETMu2-3dFEDwOgL1RQ@mail.gmail.com>
 <20130626145412.1e9bfa63@amdc308.digital.local>
Organization: SPRC Poland
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprFIsWRmVeSWpSXmKPExsVy+t9jAd22L6cCDf5eY7b483Y5q8XTph/s
	FvM+y1qs2f+TyaLz7BNmi94FV9ks3jzitnjzcDOjxeVdc9gsPvceYbS43biCzaJ/YS+TxZOH
	fWwW62e8ZrHoOPKN2WLjVw8HAY/Fe14yedy5tofNY920t8wefVtWMXo8WtzC6HH8xnYmj8+b
	5ALYo7hsUlJzMstSi/TtErgypj60KvjEXPFj02bWBsb/TF2MnBwSAiYSx3pvsUPYYhIX7q1n
	62Lk4hASWMQocWXpMnYIp51JYvb32WBVLAKqEp+XPAez2QT0JD7ffQo0iYNDREBL4uXNVJB6
	ZoHvLBLvVy9nBqkRFvCQ2L6rnxWkhlfAWuLWazmQMKeAjcT8nldgJUIC25gk+taxgNj8ApIS
	7f9+MEMcZCdx7tMGsFW8AoISPybfA6thBlq1eVsTK4QtL7F5zVvmCYyCs5CUzUJSNgtJ2QJG
	5lWMoqkFyQXFSem5hnrFibnFpXnpesn5uZsYwTH2TGoH48oGi0OMAhyMSjy8CltPBgqxJpYV
	V+YeYpTgYFYS4X0z/1SgEG9KYmVValF+fFFpTmrxIUZpDhYlcd4DrdaBQgLpiSWp2ampBalF
	MFkmDk6pBsawlqj0pwmPI9Yzxtb6+V9+ejNRq4Hlp4Sn99zzLf5S7y461v/I7vApmGMQ26Ai
	4li0UmLBbk3N7QFvnfdXZUgVCG8+9+PGode/PFinHwm3Mlm4dSGzz9NHf9bazJ0xMcLc6fvl
	A/f3ht16eFV93t9A6+StxpxTbQ+cW3bUSv6773v5OxtnCikqsRRnJBpqMRcVJwIAXtw+wK0C	AAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Jun 2013 14:54:12 +0200, Lukasz Majewski wrote:
> > >
> > > +int cpufreq_boost_trigger_state(int state);  
> > 
> > Why is this present here?  
> 
> We had agreed to talk only about cpufreq :-).
> 
> This declaration will be removed.

Correction:

This declaration is needed for allowing disabling cpufreq boost at
thermal subsystem (please refer to [PATCH v4 7/7]).


-- 
Best regards,

Lukasz Majewski

Samsung R&D Institute Poland (SRPOL) | Linux Platform Group
