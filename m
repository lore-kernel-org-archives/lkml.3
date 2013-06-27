Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752306Ab3F0GcH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 02:32:07 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:48378 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752152Ab3F0GcE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 02:32:04 -0400
X-AuditID: cbfee61b-b7f8e6d00000524c-99-51cbdc62eebc
Date: Thu, 27 Jun 2013 08:31:51 +0200
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
Message-id: <20130627083151.3deb06a6@amdc308.digital.local>
In-reply-to: <CAKohpo=G+BJVDVs3ToajkUobQHBeY2GZ3nzyKHc3vechmLTLXQ@mail.gmail.com>
References: <1370502472-7249-1-git-send-email-l.majewski@samsung.com>
 <1370941408-29304-1-git-send-email-l.majewski@samsung.com>
 <1370941408-29304-4-git-send-email-l.majewski@samsung.com>
 <CAKohponJ5FyuKywCGz5j8GYomwqEJ0B-CvJybp+_eLjrsRkXDA@mail.gmail.com>
 <20130626155823.47eb36fb@amdc308.digital.local>
 <CAKohpo=G+BJVDVs3ToajkUobQHBeY2GZ3nzyKHc3vechmLTLXQ@mail.gmail.com>
Organization: SPRC Poland
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrPLMWRmVeSWpSXmKPExsVy+t9jAd2kO6cDDbruy1j8ebuc1eJp0w92
	i3mfZS06zz5htuhdcJXN4s0jbovLu+awWXzuPcJocbtxBZtF/8JeJouOI9+YLTZ+9XDg8bhz
	bQ+bx7ppb5k9+rasYvR4tLiF0ePzJrkA1igum5TUnMyy1CJ9uwSujIZ1S5gLlrNWfG34z9jA
	2M7SxcjJISFgIvHv2AQ2CFtM4sK99UA2F4eQwCJGiWvX5rJDOO1MEvvf3gfrYBFQleg9t4Ad
	xGYT0JP4fPcpUxcjB4eIgJbEy5upIPXMAs+YJR5/WcMKUiMskCIx8fh+RhCbV8Ba4sTcx0wg
	NqdAsETvlIMsEAv+M0m0/lvPDJLgF5CUaP/3gxniJDuJc582sEM0C0r8mHwP7AhmoGWbtzWx
	QtjyEpvXvGWewCg4C0nZLCRls5CULWBkXsUomlqQXFCclJ5rpFecmFtcmpeul5yfu4kRHC3P
	pHcwrmqwOMQowMGoxMP7gfF0oBBrYllxZe4hRgkOZiUR3tAcoBBvSmJlVWpRfnxRaU5q8SFG
	aQ4WJXHeg63WgUIC6YklqdmpqQWpRTBZJg5OqQbGlYFzyp1vVx258/jb+VeFHavFHsrz2xRN
	CauMKSmqqzF12Lrlv9reWWEV/7UcYmOnLKpnTq2QTNm/hH+T+A/3F1s3anGZTD50LPfjmYld
	nWccw7//7+nfclrvX6Logfde006k3w94I/lH9eaRoGk1Kb/nX3gSNWlynYrk7gv7vfxm6cdG
	2MTnKLEUZyQaajEXFScCAJYNniySAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Jun 2013 09:32:56 +0530, Viresh Kumar wrote:

> On 26 June 2013 19:28, Lukasz Majewski <l.majewski@samsung.com> wrote:
> > On Wed, 26 Jun 2013 16:35:32 +0530, Viresh Kumar wrote:
> >> This patch is still few generations back :)
> >
> > But this is v2 version of boost patches.
> 
> My mistake....
> 
> > Please also review:
> > [PATCH v4 4/7]
> > [PATCH v4 5/7]
> > [PATCH v4 6/7]
> > [PATCH v4 7/7] - disable boost at thermal framework
> 
> don't worry I will review everything. I went home after reviewing half
> of the patches.

Ok, Thanks.

-- 
Best regards,

Lukasz Majewski

Samsung R&D Institute Poland (SRPOL) | Linux Platform Group
