Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754168AbaLHHol (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 02:44:41 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:19379 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754007AbaLHHoj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 02:44:39 -0500
X-AuditID: cbfee68f-f791c6d000004834-43-548556e634c9
Date: Mon, 08 Dec 2014 07:44:38 +0000 (GMT)
From: MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: Re: [RFC RESEND 0/3] Add watermark support to devfreq
To: Arto Merilainen <amerilainen@nvidia.com>,
        =?utf-8?Q?=EB=B0=95=EA=B2=BD=EB=AF=BC?= <kyungmin.park@samsung.com>,
        "tomeu.vizoso@collabora.com" <tomeu.vizoso@collabora.com>,
        "gnurou@gmail.com" <gnurou@gmail.com>
Cc: "javier.martinez@collabora.co.uk" <javier.martinez@collabora.co.uk>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "thierry.reding@gmail.com" <thierry.reding@gmail.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "srasal@nvidia.com" <srasal@nvidia.com>
Reply-to: myungjoo.ham@samsung.com
MIME-version: 1.0
X-MTR: 20141208072213728@myungjoo.ham
Msgkey: 20141208072213728@myungjoo.ham
X-EPLocale: ko_KR.utf-8
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-MLAttribute: 
X-RootMTR: 20141208072213728@myungjoo.ham
X-ParentMTR: 
X-ArchiveUser: 
X-CPGSPASS: N
X-ConfirmMail: N,general
Content-type: text/plain; charset=utf-8
MIME-version: 1.0
Message-id: <1555621726.710701418024675477.JavaMail.weblogic@epmlwas04c>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrEIsWRmVeSWpSXmKPExsWyRsSkWPdZWGuIwcpXfBaXd81hc2D0+LxJ
	LoAxissmJTUnsyy1SN8ugSujfc8ZtoI1+hXXnj9iamDs0eti5OQQElCXWLTkJBuILSFgItE1
	oZ0RwhaTuHBvPVCcC6hmKaPEqeP/gBwOsKLrh5wg4nMYJTY0fWIFibMIqEj8+6kNYrIJ6EnM
	/JwMMkZYwE6if/ZpFpByEYG7jBKLpvazgjjMAueYJS41/mGGOEJJYs2+VywgNq+AoMTJmU9Y
	II5QlZi95wXYfF4BNYmlvdYQYXGJC3MvsUPYvBIz2p9ClctJTPu6hhnClpY4P2sD3C+Lvz+G
	ivNLHLu9gwnCFpCYeuYgVI2WxJT3E6Dm8EmsWfiWBaZ+16nlzDC77m+ZC9UrIbG15QkriM0s
	oCgxpfshO8iZzAKaEut36aP7hFfAQ+LM9XPgcJAQmMkh8fDvUuYJjEqzkNTNQjJqFsIoZCUL
	GFlWMYqmFiQXFCelFxnrFSfmFpfmpesl5+duYgQmhdP/nvXvYLx7wPoQowAHoxIP74IHLSFC
	rIllxZW5hxhNgZE0kVlKNDkfmHrySuINjc2MLExNTI2NzC3NlMR5F0r9DBYSSE8sSc1OTS1I
	LYovKs1JLT7EyMTBKdXAWPmR+9SjizPbN7zP0cz9XLfow+ZT6w0FJ6/jsIqvuzoj6d2mwxvt
	L7ybf9xk4oyz4vdY73qVi2ZXeLX/3LBXZCWr6o35qgu7NPIO/y3aff7hJZfNJjLy2507am1U
	t/14bRUXt8Mg5IzMyohva6c2Tp39TrDuQkCQ/8Pig0VPkgUfl3CLRl0N5lFiKc5INNRiLipO
	BACutXzMBQMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrMKsWRmVeSWpSXmKPExsVy+t/tft1nYa0hBq1N7BaXd81hc2D0+LxJ
	LoAxKs0mIzUxJbVIITUvOT8lMy/dVsk7ON453tTMwFDX0NLCXEkhLzE31VbJxSdA1y0zB2io
	kkJZYk4pUCggsbhYSd/Opii/tCRVISO/uMRWKdrQ3EjPyEDP1EjP0DjWytDAwMgUqCYhLaN9
	zxm2gjX6FdeeP2JqYOzR62Lk5BASUJdYtOQkWxcjB4eEgInE9UNOIGEJATGJC/fWA4W5gErm
	MEpsaPrEClLDIqAi8e+nNojJJqAnMfNzMki5sICdRP/s0ywg5SICdxklFk3tZwVxmAXOMUtc
	avzDDLFLSWLNvlcsIDavgKDEyZlPWCCWqUrM3vMCbD6vgJrE0l5riLC4xIW5l9ghbF6JGe1P
	ocrlJKZ9XcMMYUtLnJ+1gRHm5sXfH0PF+SWO3d7BBGELSEw9cxCqRktiyvsJUHP4JNYsfMsC
	U7/r1HJmmF33t8yF6pWQ2NryhBXEZhZQlJjS/ZAd5ExmAU2J9bv00X3CK+Ahceb6OZYJjLKz
	kKRmIemehdCNrGQBI8sqRtHUguSC4qT0CkO94sTc4tK8dL3k/NxNjOAE9GzhDsYv560PMQpw
	MCrx8C540BIixJpYVlyZe4hRgoNZSYTX0741RIg3JbGyKrUoP76oNCe1+BCjKTDKJjJLiSbn
	A5NjXkm8obGxiZmJqaWJhYGpuZI47/9zuSFCAumJJanZqakFqUUwfUwcnFINjIJ3uT9vVnlg
	tbRWgf+ZusnXGe6J00ssHx0Udi/vFZ2o1r+JhXGP1NPr2jUcwlZujpk72lYnrzvdUcnieIil
	ZmJi8NMj5wQ0l3G/0Nn4Z6mkv12p89kb0uyzfupPnbEyd8OK8r9bF01+2b9qRchso9NcWjqc
	s3dHpBSfWS2V1jm/QPmQ752Xe5RYijMSDbWYi4oTAeH+kONWAwAA
DLP-Filter: Pass
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id sB87iq3m023673

> (Sorry for the spam. I am resending the series because I noted that
> some of the email addresses were mistyped)
> 
> Currently main mechanism to implement scaling using devfreq is
> polling and the device profile is free to set polling interval.
> However, in many cases this approach is not optimal; We may
> unnecessarily use CPU time to determine load on engine that
> is idle most of time - or we may simply read load when we
> already know that the device is busy.
> 
> In some cases a device itself has counters to track its activity
> and possibility to raise interrupts when load goes above or below
> certain threshold.
> 
> This series adds support for watermark events to devfreq and
> introduces two example governors. The first patch adds two
> callbacks to the device profile (for setting watermark) and
> adds a new function call to devfreq that informs of crossed
> watermark.
> 
> The added governors demonstrate usage of the new API. The first
> governor (watermark simple) sets device to trigger low watermark
> event when load goes below 10% and high watermark interrupt when
> the load goes above 60%. Watermark active tries to keep load at
> certain level and it actively sets thresholds based on the
> frequency table in order get interrupts only when the load value
> would affect to the current frequency in re-estimation.

Hi Arto,


Please let me start with somewhat naive high-level question:
  What do you mean by watermark in this context?
Is it a product name of yours (interrupt-based PMU, I presume)?
Or does watermark have another semantics that I am not aware of?
Or do you really mean something like
  http://en.wikipedia.org/wiki/Digital_watermarking

Other itching points include:
- devfreq_watermark_event() was declared but has never been used.
    Who is supposed to call this function?
- Is enum watermark_type supposed to be used out of /drivers/devfreq/* ?
    Otherwise, please move it inside /drivers/devfreq/governor.h
    (I guess it is to be used inside corresponding governors only)
- Could you please watermark-specific interfaces (set_high/low_wmark) into
    its own public header file? (e.g., /include/linux/devfreq/governor_wmark.h)
  I think we can create another (governor_simpleondemand.h) in there as well
    in order to have threshold values configured by device drivers.
  Adding governor-specific configurations into devfreq.h seems not
    appropriate especially when we expect that we may need many different
    governors.

  OR..

  This seems that you can keep set_h/l_wmark functions exposed to
    drivers/devfreq/* only. Therefore, having /drivers/devfreq/governor_wmark.h
    should be sufficient as well, which should be more neat than the above.
  The callbacks are to be defined by the devfreq drivers, aren't they?

- The event name, "DEVFREQ_GOV_WMARK", defined in governor.h, seems to be
    more appropriate if it is named "DEVFREQ_GOV_INTERNAL" as we won't need
    to define event names for each govornor's internal needs.

  OR.. for more generality,
    we may define a macro like:

#define DEVFREQ_GOV_INTERNAL(value)	((0x1 << 31) | (value))
#define GET_DEVFREQ_GOV_INTERNAL(event)	((event) & ~(0x1 << 31))

- In general, I would love to see governors with minimal intervention on
    the framework core/main code, especially when it is not beneficial to
    other governors. Unlike cpufreq, we may contain many different types of
    devices in devfreq, which has the potential to accompany many different
    governors.


Cheers,
MyungJoo.

> 
> Arto Merilainen (1):
>   PM / devfreq: Add watermark active governor
> 
> Shridhar Rasal (2):
>   PM / devfreq: Add watermark events
>   PM / devfreq: Add watermark simple governor
> 
>  drivers/devfreq/Kconfig                 |  18 +++
>  drivers/devfreq/Makefile                |   2 +
>  drivers/devfreq/devfreq.c               |  19 +++
>  drivers/devfreq/governor.h              |   1 +
>  drivers/devfreq/governor_wmark_active.c | 276 ++++++++++++++++++++++++++++++++
>  drivers/devfreq/governor_wmark_simple.c | 245 ++++++++++++++++++++++++++++
>  include/linux/devfreq.h                 |  26 +++
>  7 files changed, 587 insertions(+)
>  create mode 100644 drivers/devfreq/governor_wmark_active.c
>  create mode 100644 drivers/devfreq/governor_wmark_simple.c
> 
> -- 
> 1.8.1.5
> 
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
