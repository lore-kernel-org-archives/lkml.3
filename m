Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754660Ab3H1RYs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 13:24:48 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:17377 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753566Ab3H1RYr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 13:24:47 -0400
X-AuditID: cbfec7f5-b7ef66d00000795a-ad-521e325c70be
Message-id: <521E3259.6040201@samsung.com>
Date: Wed, 28 Aug 2013 20:24:41 +0300
From: Dmitry Kasatkin <d.kasatkin@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803
 Thunderbird/17.0.8
MIME-version: 1.0
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, sedat.dilek@gmail.com,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-next <linux-next@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-usb@vger.kernel.org
Subject: Re: linux-next: Tree for Aug 28 [ xhci build breakage ]
References: <CA+icZUUTBYMxLPBv2fq86h3dxyANhtpd6=Q4XGMscrntPNA9bQ@mail.gmail.com>
 <CA+icZUW6JMa6VoRJ62AUZDpYm2_q_tzSM0Ryb56RNnCdEhwQyA@mail.gmail.com>
 <CA+icZUVTzMxS4f3kZnauDkrpf4vwMbS3zd7ECOhE37S_FF83UA@mail.gmail.com>
 <CA+icZUVsG-1J2oYF+AeHsxonG2ABW4d0464yijNwaq7R5k94SQ@mail.gmail.com>
 <521DD43D.7070605@samsung.com>
 <CA+icZUWQp0k8jMqY=_DYW2Ev1cEhpev=iQNnc=NbHNgHNbifTA@mail.gmail.com>
 <521DD6BD.4030700@samsung.com> <20130828165938.GA26483@xanatos>
In-reply-to: <20130828165938.GA26483@xanatos>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Originating-IP: [106.210.244.194]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrMLMWRmVeSWpSXmKPExsVy+t/xq7oxRnJBBrM3mVs0L17PZnF51xw2
	i4ML2xgtFi1rZbZoPnGK2WLd1BMsFlv3XmV3YPdovHGDzWPnrLvsHvNOBnrsn7uG3ePzJrkA
	1igum5TUnMyy1CJ9uwSujOOPt7IWNHBUvHr7m72B8RJbFyMnh4SAiUTP2aOMELaYxIV764Hi
	XBxCAksZJb40fGIGSQgJNDJJXHhhC5GYzyjx/ctcFpAEr4CWxO/bc9lBbBYBVYnJ6yeBTWUT
	0JPY0PwDLC4qECGxcskDVoh6QYkfk++B9YoI6EtMnNoDto1Z4BGjxMGuh2AJYQEHiQmPHrBD
	bLvILPH5yxawSZwCuhITFq9nArGZBXQk9rdOY4Ow5SU2r3kLdaqqRPfatVC/KUtcfrmdZQKj
	8Cwky2chaZ+FpH0BI/MqRtHU0uSC4qT0XCO94sTc4tK8dL3k/NxNjJCI+bqDcekxq0OMAhyM
	Sjy8DD9lg4RYE8uKK3MPMUpwMCuJ8P4WkQsS4k1JrKxKLcqPLyrNSS0+xMjEwSnVwNjL+plZ
	pTk0X/Lg42dSS6/fOb7cNvnt04RfrQ215XMfFxz9cHydb+AS6503TG3Pv5P0ueH2Q8l5dUDA
	njUZYbcq9+2wElJ9NnmKe0bZyUcMupVR9xm3+7YI/rnVmdN2UJVfXOur5rr7nncN/Z2Py6Wt
	fM/9SHVrunmmWY7iBt+fgX6ZnZtLpZVYijMSDbWYi4oTAYSnRml2AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28/08/13 19:59, Sarah Sharp wrote:
> Please trim your replies.
>
> On Wed, Aug 28, 2013 at 01:53:49PM +0300, Dmitry Kasatkin wrote:
>>>>> That change seems to cause the problems:
>>>>>
>>>>> commit 0730d52a86919300a39a2be37f6c140997dfb82f
>>>>> "xhci:prevent "callbacks suppressed" when debug is not enabled"
>>>>>
>>>>> - Sedat -
>>>>>
>>>>> [1] http://git.kernel.org/cgit/linux/kernel/git/gregkh/usb.git/commit/drivers/usb/host/xhci-ring.c?h=usb-next&id=0730d52a86919300a39a2be37f6c140997dfb82f
>>>>>
>>>> Hello,
>>>>
>>>> [PATCHv2 1/2] was not applied before.
>>>> I pointed this out few hours ago...
> So commit 0730d52a86919300a39a2be37f6c140997dfb82f 'xhci:prevent
> "callbacks suppressed" when debug is not enabled' needed to be applied
> after your first patch?  And basically applying that patch alone breaks
> the build?

Right...
May be I had to stress it somehow... sorry.

> Ugh.  Sorry about this.  Greg, how do you want to handle this?
>
> Sarah "needs a vacation" Sharp
>


