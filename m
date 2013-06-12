Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755124Ab3FLGA2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 02:00:28 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:25319 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754679Ab3FLGA0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 02:00:26 -0400
X-AuditID: cbfee61b-b7f8e6d00000524c-0c-51b80e784412
Date: Wed, 12 Jun 2013 08:00:02 +0200
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
Subject: Re: [PATCH v2 0/3] cpufreq:boost: CPU Boost mode support
Message-id: <20130612080002.3f382ee1@amdc308.digital.local>
In-reply-to: <CAKohpo=VpMvxMb-r4Hgga1ZM9m9egyUH_Ee+S=q25RdT7DAE-Q@mail.gmail.com>
References: <1370502472-7249-1-git-send-email-l.majewski@samsung.com>
 <1370941408-29304-1-git-send-email-l.majewski@samsung.com>
 <CAKohpo=VpMvxMb-r4Hgga1ZM9m9egyUH_Ee+S=q25RdT7DAE-Q@mail.gmail.com>
Organization: SPRC Poland
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrLLMWRmVeSWpSXmKPExsVy+t9jQd0Kvh2BBveuslv8ebuc1eJp0w92
	i3mfZS06zz5htuhdcJXN4s0jbovLu+awWXzuPcJocbtxBZtF/8JeJouOI9+YLTZ+9XDg8bhz
	bQ+bx7ppb5k9+rasYvR4tLiF0ePzJrkA1igum5TUnMyy1CJ9uwSujD03TzAWnOCsmP1tInMD
	4wH2LkZODgkBE4kn+z9B2WISF+6tZ+ti5OIQEpjOKPHz02MmkISQQDuTxMFmCxCbRUBVoqFv
	DxuIzSagJ/H57lOgGg4OEQEtiZc3U0F6mQWeMUs8/rKGFaRGWMBRovvbH2YQm1fAWmLfwZ/M
	IPWcAsESL3qZIHadZJSYev8RC0gNv4CkRPu/H8wQB9lJnPu0gR2iV1Dix+R7YDXMQLs2b2ti
	hbDlJTavecs8gVFwFpKyWUjKZiEpW8DIvIpRNLUguaA4KT3XSK84Mbe4NC9dLzk/dxMjOFKe
	Se9gXNVgcYhRgINRiYf3gNn2QCHWxLLiytxDjBIczEoivLq5QCHelMTKqtSi/Pii0pzU4kOM
	0hwsSuK8B1utA4UE0hNLUrNTUwtSi2CyTBycUg2MzXc0/7rX5L3davb89ve0hTERYV/uFB+q
	FHFSi1meL7ZRzMXVclVmY8kUh2yzt29OHpvFlKnzjfFrDceyyUGPRK6UTU3ItY7XeOQkxei0
	9MGpZN1pDjflSj8Jmc4K/WN2MtxnYWdws/6yxEt2AWKGj6/NexXwcJbOxY1dHbtVXr1i0mbm
	l3+txFKckWioxVxUnAgA4zyiB5ACAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Viresh,

> On 11 June 2013 14:33, Lukasz Majewski <l.majewski@samsung.com> wrote:
> > This patch series introduces support for CPU overclocking technique
> > called Boost.
> >
> > It is a follow up of a LAB governor proposal. Boost is a LAB
> > component:
> > http://thread.gmane.org/gmane.linux.kernel/1484746/match=cpufreq
> >
> > Boost unifies hardware based solution (e.g. Intel Nehalem) with
> > software oriented one (like the one done at Exynos).
> > For this reason cpufreq/freq_table code has been reorganized to
> > include common code.
> 
> To be honest, I haven't given a review to patches 2/3 and 3/3 as I am
> concerned more about 1/3.

As you pointed out in the other mail 1/3 has its own issues, but I
think that patches 2/3 and 3/3 are an integral part of the boost
support and bring better overall overview to the design.

> 
> Maybe you can just send v3 of 1/3. 2/3 and 3/3 can be sent when we
> have finalized 2/3 and 3/3 's version.

I'd opt for sending the whole patchset (it shouldn't be so difficult to
adjust those patches), since it is easier for me to test.



-- 
Best regards,

Lukasz Majewski

Samsung R&D Institute Poland (SRPOL) | Linux Platform Group
