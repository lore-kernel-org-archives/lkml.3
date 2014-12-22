Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755059AbaLVOrv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 09:47:51 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:32393 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754300AbaLVOrt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 09:47:49 -0500
X-AuditID: cbfec7f5-b7fc86d0000066b7-b2-54982f12253f
Message-id: <54982F0D.6040702@samsung.com>
Date: Mon, 22 Dec 2014 15:47:41 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.1.2
MIME-version: 1.0
To: Vivek Gautam <gautamvivek1987@gmail.com>
Cc: Kukjin Kim <kgene@kernel.org>, Kishon Vijay Abraham I <kishon@ti.com>,
        Felipe Balbi <balbi@ti.com>, Vivek Gautam <gautam.vivek@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        Linux USB Mailing List <linux-usb@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Tomasz Figa <tomasz.figa@gmail.com>, robh+dt <robh+dt@kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Kukjin Kim <kgene.kim@samsung.com>
Subject: Re: [PATCH 00/11] Exynos7: Adding USB 3.0 support
References: <1416576954-11997-1-git-send-email-gautam.vivek@samsung.com>
 <20141121151130.GD7508@saruman> <54704BF0.1000903@ti.com>
 <5470A7C5.1070302@kernel.org>
 <CAFp+6iE5XJ+TGu+8TvRFd3Up-kzki3VPD4k6gPXaYbscfwnz4w@mail.gmail.com>
In-reply-to: <CAFp+6iE5XJ+TGu+8TvRFd3Up-kzki3VPD4k6gPXaYbscfwnz4w@mail.gmail.com>
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrDLMWRmVeSWpSXmKPExsVy+t/xy7pC+jNCDDb80bE4eL/eYv6Rc6wW
	bVcOslu8/b6F3aJ58Xo2i94FV9ks+h+/Zra48LSHzeLyrjlsFrOX9LNYzDi/j8li0bJWZovW
	vUfYLSb8vsBmsWrXH0YHfo+ds+6ye2xa1cnmsX/uGnaP2Xd/MHr0bVnF6HH8xnYmj8+b5ALY
	o7hsUlJzMstSi/TtErgyVs/mKPjOXnH0K2sD4wS2LkZODgkBE4klFzuZIWwxiQv31gPFuTiE
	BJYySnSeOMYIkhAS+MQosf0vmM0roCVx7cByFhCbRUBV4uD5B2A2m4ChRO/RPrAaUYEIiZN3
	97BD1AtK/Jh8D6xGREBH4lBrPwvIAmaBDlaJBxefgiWEBawkWv93s0Bsfs0oMfdCG9hJnALB
	EhN/f2btYuQA6lCXmDIlFyTMLCAvsXnNW+YJjAKzkOyYhVA1C0nVAkbmVYyiqaXJBcVJ6blG
	esWJucWleel6yfm5mxghMfR1B+PSY1aHGAU4GJV4eDtWTQsRYk0sK67MPcQowcGsJMJ7+PP0
	ECHelMTKqtSi/Pii0pzU4kOMTBycUg2MzVERuaGOJ4+Jmi5zLL45Mf1r+SZHzcA/r1+1dpqt
	lJv6588fP4vZAu29ckVmFiY2Vi+uvCg8U3Ww9N6jaiPXTwWPen21Zl7ic0+x+ia7Q/gIW+QK
	xjk+80yFTK9djnhRdeX30TgWEcZgwXX3Vn2/MEPkicIGI2/7BV8CFX5/LH+uc2/Z94WaSizF
	GYmGWsxFxYkAapinBn8CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vivek,

On 25/11/14 12:48, Vivek Gautam wrote:
> On Sat, Nov 22, 2014 at 8:42 PM, Kukjin Kim <kgene@kernel.org> wrote:
>> > On 11/22/14 17:40, Kishon Vijay Abraham I wrote:
>>> >> On Friday 21 November 2014 08:41 PM, Felipe Balbi wrote:
...
>>>> >>> I took dwc3 driver patches.
>>> >>
>>> >> I took the phy patches.
>>> >>
>> > I'll take DT changes once exynos7 is landing into samsung tree :)
>> >
> You too may want to pick the sole clock driver patch in this series
> for 3.19 ? :-)
> "clk: exynos7: Add required clock tree for USB"
> 
> Please let me know if the merge window is still open on your side so
> that you can pick this patch.

My apologies, it seems I have missed this patch. :/
Feel free to ping me off the list in future if there is no response
for more than week.
I queued this patch now for 3.20.  I'm putting all the exynos7 clk
patches on a separate branch which could then be pulled into samsung
arm tree for the dependant dts changes.

-- 
Thanks,
Sylwester
