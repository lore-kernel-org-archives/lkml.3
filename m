Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754139Ab3JCXvP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 19:51:15 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:22368 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752361Ab3JCXvJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 19:51:09 -0400
X-AuditID: cbfee691-b7f4a6d0000074fc-ec-524e02e6b8b4
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fbdev@vger.kernel.org,
        "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Thierry Reding'" <thierry.reding@gmail.com>,
        "'Tomi Valkeinen'" <tomi.valkeinen@ti.com>,
        "'Laurent Pinchart'" <laurent.pinchart+renesas@ideasonboard.com>,
        "'Michael Hennerich'" <michael.hennerich@analog.com>,
        "'Milo Kim'" <milo.kim@ti.com>,
        "'Daniel Jeong'" <gshark.jeong@gmail.com>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <017f01cebb35$f6a82ac0$e3f88040$%han@samsung.com>
 <20131003162048.d4be6510f36da5c61dc61c43@linux-foundation.org>
In-reply-to: <20131003162048.d4be6510f36da5c61dc61c43@linux-foundation.org>
Subject: Re: [PATCH] MAINTAINERS: remove Richard Purdie as backlight maintainer
Date: Fri, 04 Oct 2013 08:50:57 +0900
Message-id: <003801cec093$6b3c1bf0$41b453d0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac7AjzMSYgrbsLqLSKWLWYor1K51wgAA8OEQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpileLIzCtJLcpLzFFi42I5/e+Zoe4zJr8ggwcPrC3mrF/DZjF5dxer
	xeWFl1gtJjbdYbE40fcByN01h81iwuHN7BbLf61jsdi96ymrxc9d81gs1s+/xebA7fHqqqPH
	zll32T1md8xk9Tgx4zeLx575P1g9+rasYvQ4fmM7k8fnTXIBHFFcNimpOZllqUX6dglcGc07
	LAsOsFZ0bP3G0sC4gqWLkZNDQsBE4n/7PChbTOLCvfVsXYxcHEICyxgldjY/ZYMpOvlkAQtE
	YjqjxOot/ewQzi9GiRt7DzGBVLEJqEl8+XIYKMHBISKgL9HWogFSwyywnFli/sEXzCA1QgJ1
	Ejd/fQWr4RTwltjabg4SFhbwl1j3agIriM0ioCqx/E0/WDmvgK3ErJUzGSFsQYkfk++BXcos
	oCWxeVsTK4QtL7F5zVtmkJESAuoSj/7qgoRFBIwk/vReZocoEZHY9+IdI8g5EgJzOST2dT1i
	g9glIPFt8iEWiF5ZiU0HmCH+lZQ4uOIGywRGiVlINs9CsnkWks2zkKxYwMiyilE0tSC5oDgp
	vchUrzgxt7g0L10vOT93EyMk/ifuYLx/wPoQYzLQ+onMUqLJ+cD0kVcSb2hsZmRhamJqbGRu
	aUaasJI4r3qLdaCQQHpiSWp2ampBalF8UWlOavEhRiYOTqkGxrlLk4p1ZVr+uz4+z67PvSK+
	+/2Z3TdDZR+nMRdUaFj9KL984kPo2sI7zrt3L99otjy/emZb0KH4i9MV/p/M3PSTzdSw+f8V
	czGjwGXPnoTy3auY897mc3jNgpoDG19qLfn54aRU5qNJGbn2EeUZC6dpdrTJ2IfNNgi6tUv1
	5qVW/QereAxWeiqxFGckGmoxFxUnAgBpP2jdFQMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrPKsWRmVeSWpSXmKPExsVy+t9jQd1nTH5BBqsPm1nMWb+GzWLy7i5W
	i8sLL7FaTGy6w2Jxou8DkLtrDpvFhMOb2S2W/1rHYrF711NWi5+75rFYrJ9/i82B2+PVVUeP
	nbPusnvM7pjJ6nFixm8Wjz3zf7B69G1Zxehx/MZ2Jo/Pm+QCOKIaGG0yUhNTUosUUvOS81My
	89JtlbyD453jTc0MDHUNLS3MlRTyEnNTbZVcfAJ03TJzgC5VUihLzCkFCgUkFhcr6dthmhAa
	4qZrAdMYoesbEgTXY2SABhLWMWY077AsOMBa0bH1G0sD4wqWLkZODgkBE4mTTxZA2WISF+6t
	Z+ti5OIQEpjOKLF6Sz87hPOLUeLG3kNMIFVsAmoSX74cBkpwcIgI6Eu0tWiA1DALLGeWmH/w
	BTNIjZBAncTNX1/BajgFvCW2tpuDhIUF/CXWvZrACmKzCKhKLH/TD1bOK2ArMWvlTEYIW1Di
	x+R7YAcxC2hJbN7WxAphy0tsXvOWGWSkhIC6xKO/uiBhEQEjiT+9l9khSkQk9r14xziBUWgW
	kkmzkEyahWTSLCQtCxhZVjGKphYkFxQnpeca6RUn5haX5qXrJefnbmIEJ5dn0jsYVzVYHGIU
	4GBU4uHdUOwbJMSaWFZcmXuIUYKDWUmE9/QnoBBvSmJlVWpRfnxRaU5q8SHGZKBHJzJLiSbn
	AxNfXkm8obGJmZGlkZmFkYm5OWnCSuK8B1utA4UE0hNLUrNTUwtSi2C2MHFwSjUwavPnKC5O
	15HiMr+YVmva65ByeDeX+2x7lgkOtUEKa7qmPTokumSbTNincOmHyxcp8VryeX2Oy7a+u/BZ
	aHVFplR+SLf7gikSBxrLfG83iU4LEw/I0FvVuyRpnp5qB99aPgNGM+Gu9qa3e6/GTdJY+aTG
	rczs4tNlvr319t/mvPbQ2S1QPU+JpTgj0VCLuag4EQAbS6PacgMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, October 04, 2013 8:21 AM, Andrew Morton wrote:
> On Fri, 27 Sep 2013 12:59:28 +0900 Jingoo Han <jg1.han@samsung.com> wrote:
> 
> > Remove Richard Purdie as backlight subsystem maintainer, since he
> > is not responding for a few years.
> 
> It's nice to give a person a ./CREDITS entry when we remove them from
> ./MAINTAINERS.

However, Richard Purdie still remains as maintainers of other two entries
as below:
In this case, is it still necessary give him a ./CREDITS entry?

ARM/CORGI MACHINE SUPPORT
M:      Richard Purdie <rpurdie@rpsys.net>

LED SUBSYSTEM
M:      Bryan Wu <cooloney@gmail.com>
M:      Richard Purdie <rpurdie@rpsys.net>

Best regards,
Jingoo Han

