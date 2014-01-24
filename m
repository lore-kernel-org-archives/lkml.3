Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752240AbaAXIUs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 03:20:48 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:25648 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751723AbaAXIUp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 03:20:45 -0500
X-AuditID: cbfee690-b7f266d00000287c-0a-52e2225cd212
From: Jingoo Han <jg1.han@samsung.com>
To: "'Liu Ying'" <Ying.Liu@freescale.com>
Cc: "'Jean-Christophe PLAGNIOL-VILLARD'" <plagnioj@jcrosoft.com>,
        "'Tomi Valkeinen'" <tomi.valkeinen@ti.com>,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org,
        "'Jani Nikula'" <jani.nikula@linux.intel.com>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <1390543476-13499-1-git-send-email-Ying.Liu@freescale.com>
In-reply-to: <1390543476-13499-1-git-send-email-Ying.Liu@freescale.com>
Subject: Re: [PATCH v4 0/2] backlight: update bl status and some bd properties
 when necessary
Date: Fri, 24 Jan 2014 17:20:44 +0900
Message-id: <000301cf18dd$2d3e9970$87bbcc50$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac8YyfZ+dFcSfAZpTbCa7EdgZ4etMAAEpthw
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrPIsWRmVeSWpSXmKPExsVy+t8zI90YpUdBBu/XS1tc+fqezWL55fWM
	FpcXXmK1ONH3gdXi8q45bBbrHr5gslg//xabxZMnJg4cHv8O9zN5vLpwh8Vj3slAj/vdx5k8
	+rasYvQ4fmM7k8fnTXIB7FFcNimpOZllqUX6dglcGctfH2MpOMxXcXdlRgPjbu4uRk4OCQET
	ibX7GhkhbDGJC/fWs3UxcnEICSxjlHg1YRs7TNHll33MEInpjBKtTz5AOb8YJXbvfckGUsUm
	oCbx5cthsA4RAXWJY4cXMYEUMQvMZpLoXPiZGSQhJOAmMXfpdLB9nALuEvt3/ASzhQXiJVY+
	2gdmswioSqz9vIwVxOYVsJX4vnsJE4QtKPFj8j0WEJtZQEti/c7jTBC2vMTmNW+B5nMAnaou
	8eivLsQNRhIrGr6wQ5SISOx78Y4R5B4JgUYOia69R6B2CUh8m3yIBaJXVmLTAWaIjyUlDq64
	wTKBUWIWks2zkGyehWTzLCQrFjCyrGIUTS1ILihOSi8y0StOzC0uzUvXS87P3cQIiewJOxjv
	HbA+xJgMtH4is5Rocj4wMeSVxBsamxlZmJqYGhuZW5qRJqwkzqv2KClISCA9sSQ1OzW1ILUo
	vqg0J7X4ECMTB6dUA2N7313HBmmHvXfbDljslA48+eneZK7amnA53/jvWglpNQtStbdN2vNz
	Xvakqy2bTgk815ot8OqEYWGhugRzzpX5ilIvzeb1JR7p+eex7dr2Ixp3fe2Kj4brbPqXMosp
	3frxdM3Ne2q1bz2S7m9m71+ntOC8cIpRptyb3+6GbBtWPvyxQ1VphYcSS3FGoqEWc1FxIgDh
	5s+bAgMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrDKsWRmVeSWpSXmKPExsVy+t9jQd0YpUdBBlM/i1lc+fqezWL55fWM
	FpcXXmK1ONH3gdXi8q45bBbrHr5gslg//xabxZMnJg4cHv8O9zN5vLpwh8Vj3slAj/vdx5k8
	+rasYvQ4fmM7k8fnTXIB7FENjDYZqYkpqUUKqXnJ+SmZeem2St7B8c7xpmYGhrqGlhbmSgp5
	ibmptkouPgG6bpk5QEcpKZQl5pQChQISi4uV9O0wTQgNcdO1gGmM0PUNCYLrMTJAAwnrGDOW
	vz7GUnCYr+LuyowGxt3cXYycHBICJhKXX/YxQ9hiEhfurWfrYuTiEBKYzijR+uQDM4Tzi1Fi
	996XbCBVbAJqEl++HGYHsUUE1CWOHV7EBFLELDCbSaJz4WewUUICbhJzl05nBLE5Bdwl9u/4
	CWYLC8RLrHy0D8xmEVCVWPt5GSuIzStgK/F99xImCFtQ4sfkeywgNrOAlsT6nceZIGx5ic1r
	3gLN5wA6VV3i0V9diBuMJFY0fGGHKBGR2PfiHeMERqFZSCbNQjJpFpJJs5C0LGBkWcUomlqQ
	XFCclJ5rqFecmFtcmpeul5yfu4kRnDaeSe1gXNlgcYhRgINRiYd3RuDDICHWxLLiytxDjBIc
	zEoivPXXgEK8KYmVValF+fFFpTmpxYcYk4EencgsJZqcD0xpeSXxhsYmZkaWRmYWRibm5qQJ
	K4nzHmi1DhQSSE8sSc1OTS1ILYLZwsTBKdXAyJB3n/0Ny0zNuQfXefnZPsu9+LW+5JhgqrLW
	jHIOgXN8kx/ypR04crDq9FH+/xOYNvjHcfOzfP3NZyAX+IAnOVZRNCN+VmW5mn6leCmj+gQF
	dVfjmVve8T2XX8l7orn3y76qxIPB3mFXL6TtL7vJG363Q1tx7Z6M9ULT1fuOL55w23vidw5H
	JZbijERDLeai4kQAZaFfp18DAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, January 24, 2014 3:05 PM, Liu Ying wrote:
> 
> We don't have to turn backlight on/off every time a blanking
> or unblanking event comes because the backlight status may
> have already been what we want. Another thought is that one
> backlight device may be shared by multiple framebuffers. We
> don't hope blanking one of the framebuffers may turn the
> backlight off for all the other framebuffers, since they are
> likely being active to display something. This patch set adds
> some logics to record each framebuffer's backlight usage to
> determine the backlight device use count and whether the
> backlight status should be updated or not.
> 
> Liu Ying (2):
>   backlight: update bd state & fb_blank properties when necessary
>   backlight: update backlight status when necessary

Thank you for sending the v4 patch.
I have no objection against this patch. However, I will wait
for other people's opinions. Then, if there is no objection,
I will ask Andrew Morton to merge this patch into mm-tree.
Thanks.

Best regards,
Jingoo Han

> 
> v3->v4:
> * Split v3 into 2 patches to separate the change for updating the
>   backlight device properties and backlight status, according to
>   the comments from Jani Nikula and Jingoo Han.
> 
> v2->v3:
> * Set fb_blank(*(int *)evdata->data) to bd->props.fb_blank
>   when we turn off a blacklight.
> * Correct some trivial typos in the commit message.
> 
> v1->v2:
> * Make the commit message be more specific about the condition
>   in which backlight device use count can be increased/decreased.
> * Correct the setting for bd->props.fb_blank.
> 
>  drivers/video/backlight/backlight.c |   28 +++++++++++++++++++++-------
>  include/linux/backlight.h           |    6 ++++++
>  2 files changed, 27 insertions(+), 7 deletions(-)
> 
> --
> 1.7.9.5


