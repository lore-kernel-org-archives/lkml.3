Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030491Ab3FUGXq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 02:23:46 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:28128 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030248Ab3FUGXo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 02:23:44 -0400
X-AuditID: cbfee61b-b7f8e6d00000524c-78-51c3f16e36de
Date: Fri, 21 Jun 2013 08:23:34 +0200
From: Lukasz Majewski <l.majewski@samsung.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Viresh Kumar <viresh.kumar@linaro.org>,
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
        Eduardo Valentin <eduardo.valentin@ti.com>
Subject: Re: [PATCH v4 2/7] cpufreq: Add boost frequency support in core
Message-id: <20130621082334.655189ec@amdc308.digital.local>
In-reply-to: <5038475.Kzi1Kavss7@vostro.rjw.lan>
References: <1370502472-7249-1-git-send-email-l.majewski@samsung.com>
 <1371661969-7660-3-git-send-email-l.majewski@samsung.com>
 <CAKohpo=5ZJp6JBVVA0NinTMO5FUwtfy3QAabcTwVOW6TmEfs9g@mail.gmail.com>
 <5038475.Kzi1Kavss7@vostro.rjw.lan>
Organization: SPRC Poland
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprEIsWRmVeSWpSXmKPExsVy+t9jAd28j4cDDbZst7D483Y5q8XTph/s
	FvM+y1qs2f+TyaLz7BNmi94FV9ks3jzitri8aw6bxefeI4wWtxtXsFn0L+xlsnjysI/NouPI
	N2aLjV89HPg8Fu95yeRx59oeNo91094ye/RtWcXo8WhxC6PH8RvbmTw+b5ILYI/isklJzcks
	Sy3St0vgyjj58DdzwUz2iimXUxsYD7F2MXJwSAiYSCy+pdrFyAlkiklcuLeerYuRi0NIYBGj
	xJWL+5ggnHYmif7Hl1hBqlgEVCW+nf7MBGKzCehJfL77FMwWAYpvefKfHaSBWWAPi8T+bfvA
	EsICHhLbd/WDNfMKWEucvD6bBcTmFDCQWLHsMzPEhneMElsPbmYESfALSEq0//vBDHGTncS5
	TxvYIZoFJX5MvgfWzCygJbF5WxMrhC0vsXnNW+YJjIKzkJTNQlI2C0nZAkbmVYyiqQXJBcVJ
	6blGesWJucWleel6yfm5mxjBMfVMegfjqgaLQ4wCHIxKPLwBSocDhVgTy4orcw8xSnAwK4nw
	Bt8BCvGmJFZWpRblxxeV5qQWH2KU5mBREuc92GodKCSQnliSmp2aWpBaBJNl4uCUamBk/aP3
	YMHbLcVy/gErZPydLs6SYmpvcDp0OHCb/OPuLfs2P5gSwJ1jKmcl/3GFtU7OAvkq9Zfn3TR5
	7xZ83yz9uEW+6a3R5oZ2+bA8vr8lHo9Od+Qm815fW5q9Puvqw6yvTB68Hw83uRmdevzmxSLr
	dVaz/OW/Lxd4cq+polx1FlPG5+8frYWVWIozEg21mIuKEwE57RZVpQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Jun 2013 22:03:45 +0200, Rafael J. Wysocki wrote:

Hi Rafael,

> On Thursday, June 20, 2013 10:43:08 AM Viresh Kumar wrote:
> > On 19 June 2013 22:42, Lukasz Majewski <l.majewski@samsung.com>
> > wrote:
> > 
> > > Boost sysfs attribute is always exported (to support legacy API).
> > > By default boost is exported as read only. One global attribute
> > > is available at: /sys/devices/system/cpu/cpufreq/boost.
> > 
> > You asked me and Rafael a question and posted your next version
> > without even waiting for our replies? That will waste your time and
> > ours too reviewing it.
> 
> I believe I replied to that (in a different branch of the thread).
> 
> And the reply was: Do not expose if not supported.

Thanks for reply. Understood :-)

> 
> Thanks,
> Rafael
> 
> 



-- 
Best regards,

Lukasz Majewski

Samsung R&D Institute Poland (SRPOL) | Linux Platform Group
