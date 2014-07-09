Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754428AbaGIEHf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 00:07:35 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:27762 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751224AbaGIEHd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 00:07:33 -0400
X-AuditID: cbfee691-b7f2f6d0000040c4-41-53bcc0039947
From: Jingoo Han <jg1.han@samsung.com>
To: "'Sachin Kamat'" <spk.linux@gmail.com>,
        "'Tomasz Figa'" <t.figa@samsung.com>
Cc: "'open list'" <linux-kernel@vger.kernel.org>,
        "'linux-samsung-soc'" <linux-samsung-soc@vger.kernel.org>,
        "'Kishon Vijay Abraham I'" <kishon@ti.com>,
        "'Doug Anderson'" <dianders@chromium.org>,
        "'Vivek Gautam'" <gautam.vivek@samsung.com>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <1404118582-21993-1-git-send-email-sachin.kamat@samsung.com>
 <53BC122C.9090505@samsung.com>
 <CAK5sBcHJeK5=LrYfBO5C4Ht1upLes2ynvofuhBo3_xYsxGO1=g@mail.gmail.com>
In-reply-to: <CAK5sBcHJeK5=LrYfBO5C4Ht1upLes2ynvofuhBo3_xYsxGO1=g@mail.gmail.com>
Subject: Re: [PATCH 1/2] phy: Kconfig: Re-organize Exynos USB 2.0 PHY configs
Date: Wed, 09 Jul 2014 13:07:31 +0900
Message-id: <001701cf9b2b$4e228d60$ea67a820$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac+bJ/X8ycY5F9PGQlWbXK/+WQjnBwAAvMxw
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrOIsWRmVeSWpSXmKPExsVy+t8zY13mA3uCDa4sV7Y4u+wgm0XblYPs
	FpcXXmK1uPC0h83i8q45bBYzzu9jsmj5eo7FYv2M1ywOHB6zGy6yeOycdZfdo2/LKkaP4ze2
	M3l83iQXwBrFZZOSmpNZllqkb5fAlbGu5QZbwRu2iqbTs1gbGNeydjFyckgImEh8eNXJBGGL
	SVy4t56ti5GLQ0hgGaPErxnnGWGK7p5+DJVYxCix8ckmZgjnN6PEo7+f2UCq2ATUJL58Ocze
	xcjBISLgI/F3fgZIDbPARCaJ028mQ3VvYJRYPmEqO0gDp0CwxJf2CWArhAV8JY41/gS7iUVA
	VWL5y/NgQ3kFbCUafz9mh7AFJX5MvscCYjMLqEtMmreIGcKWl9i85i0zyGIJoPijv7ogYREB
	I4nOlrdQ5SIS+168g/rmI7vE1Cl8EKsEJL5NPsQC0SorsekAM0SJpMTBFTdYJjBKzEKyeBaS
	xbOQLJ6FZMMCRpZVjKKpBckFxUnpRaZ6xYm5xaV56XrJ+bmbGCGRPHEH4/0D1ocYk4HWT2SW
	Ek3OByaCvJJ4Q2MzIwtTE1NjI3NLM9KElcR50x8lBQkJpCeWpGanphakFsUXleakFh9iZOLg
	lGpgXLDx1pv2L2rMX17d0jGo+7pi+dz9iX9yAjIUlT7fsY38efvwshJrZ5clcszTDvHeas02
	5FB+9Smg/7fPhxlBdz3Fg66n/2/jcmic+kNi2jcLQ5bnZ6f88f9Q8b3eVDPuePCeal8Po+bY
	o4UHDk77cOD51yVpLml6WjOlT8jzSP7T4pTu04vKU2Ipzkg01GIuKk4EAGQqak76AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprOKsWRmVeSWpSXmKPExsVy+t9jAV3mA3uCDXqfyVmcXXaQzaLtykF2
	i8sLL7FaXHjaw2ZxedccNosZ5/cxWbR8PcdisX7GaxYHDo/ZDRdZPHbOusvu0bdlFaPH8Rvb
	mTw+b5ILYI1qYLTJSE1MSS1SSM1Lzk/JzEu3VfIOjneONzUzMNQ1tLQwV1LIS8xNtVVy8QnQ
	dcvMATpGSaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5vSBBcj5EBGkhYx5ixruUGW8Ebtoqm
	07NYGxjXsnYxcnJICJhI3D39mA3CFpO4cG89kM3FISSwiFFi45NNzBDOb0aJR38/g1WxCahJ
	fPlymL2LkYNDRMBH4u/8DJAaZoGJTBKn30yG6t7AKLF8wlR2kAZOgWCJL+0TGEFsYQFfiWON
	P8FWswioSix/eR5sKK+ArUTj78fsELagxI/J91hAbGYBdYlJ8xYxQ9jyEpvXvGUGWSwBFH/0
	VxckLCJgJNHZ8haqXERi34t3jBMYhWYhmTQLyaRZSCbNQtKygJFlFaNoakFyQXFSeq6RXnFi
	bnFpXrpecn7uJkZwongmvYNxVYPFIUYBDkYlHl4Fnj3BQqyJZcWVuYcYJTiYlUR4v7kBhXhT
	EiurUovy44tKc1KLDzGaAj06kVlKNDkfmMTySuINjU3MjCyNzCyMTMzNlcR5D7ZaBwoJpCeW
	pGanphakFsH0MXFwSjUwCj0wrZqdf++KwL3VB0NDHq7L2bg3d5W2tMW9F9v8DnaressIKCxs
	S/udb1F1x/Wze+v2wsR0/zQDq59s4W+efFkya/ls69TlYVn/z3guqeR26JIrOM3Hd+LusXXf
	3dI6ogT6P75atnrXh9u7F9fJREV1+IuJ+HaeZZ7bcCGg1MRjpZ9YflmAEktxRqKhFnNRcSIA
	KgTzvyoDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, July 09, 2014 12:42 PM, Sachin Kamat wrote:
> On Tue, Jul 8, 2014 at 9:15 PM, Tomasz Figa <t.figa@samsung.com> wrote:
> > On 30.06.2014 10:56, Sachin Kamat wrote:
> >> Since the USB 2.0 PHYs are required only with EHCI/OHCI USB drivers,
> >
> > That's not true. They are also required for USB gadget controller
> > supported by the DWC2 gadget driver (formerly s3c-hsotg). Otherwise the
> > change makes sense to me.
> 
> Do you propose I amend just the patch description or also add a dependency on
> USB_DWC2 along with EHCI and OHCI. I do not have anything to test this. Based
> on your input I will re-spin the patch.

I agree with Tomasz Figa's statement. Personally, I think that it would
be good to amend the commit message and add a dependency on USB_DWC2. :-)
Thank you.

Best regards,
Jingoo Han

> 
> --
> Regards,
> Sachin.

