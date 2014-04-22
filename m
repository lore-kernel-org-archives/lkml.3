Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752562AbaDVCSs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 22:18:48 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:64003 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751217AbaDVCSn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 22:18:43 -0400
X-AuditID: cbfee691-b7f3e6d000002ce8-1b-5355d182bfd0
From: Jingoo Han <jg1.han@samsung.com>
To: "'Vivek Gautam'" <gautam.vivek@samsung.com>,
        "'Tomasz Figa'" <t.figa@samsung.com>
Cc: "'Linux USB Mailing List'" <linux-usb@vger.kernel.org>,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        "'kishon'" <kishon@ti.com>, "'Greg KH'" <gregkh@linuxfoundation.org>,
        "'Felipe Balbi'" <balbi@ti.com>,
        "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Kamil Debski'" <k.debski@samsung.com>,
        "'Sylwester Nawrocki'" <sylvester.nawrocki@gmail.com>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <1396967803-28868-1-git-send-email-gautam.vivek@samsung.com>
 <1396967803-28868-2-git-send-email-gautam.vivek@samsung.com>
 <534529B2.2020107@samsung.com>
 <CAFp+6iEzaxCQNkGZWuBnAaAHk0uXrX4KhjVbaJfZFChB6uzk4A@mail.gmail.com>
 <53454C11.7060607@samsung.com>
 <CAFp+6iHU0YXj18ajDwOqPh_SJWr6GkMPRr6qaGdmPoCc0+tz5g@mail.gmail.com>
 <CAFp+6iH7-O8pNNMrk7Yhg1u+DXcXD1Tp9RYdiFg+-Om5Toojfw@mail.gmail.com>
 <534E892B.6090409@samsung.com>
 <CAFp+6iGYfz+ZT9zxgeVefLhtb0mb-=K4faUZC+1FtQoO0hMoqw@mail.gmail.com>
In-reply-to: <CAFp+6iGYfz+ZT9zxgeVefLhtb0mb-=K4faUZC+1FtQoO0hMoqw@mail.gmail.com>
Subject: Re: [PATCH V4 1/5] phy: Add new Exynos5 USB 3.0 PHY driver
Date: Tue, 22 Apr 2014 11:18:41 +0900
Message-id: <001101cf5dd1$2e04d390$8a0e7ab0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac9ZgwxcTlMNAetYTHK0nSNYI6uSrAER3AAg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuplleLIzCtJLcpLzFFi42I5/e+ZsW7TxdBgg0v9HBYH79dbzD9yjtWi
	7cpBdovmxevZLC4vvMRq8eP1BTaL3gVX2SwuPO1hs9j0+BqrxcK2JSwWl3fNYbOYcX4fk8Wi
	Za3MFvM+72SyWD/jNYsDv8fOWXfZPfbPXcPusXlJvUffllWMHsdvbGfy+LxJLoAtissmJTUn
	syy1SN8ugSvj0OHTbAXvxCom7F/O2MD4TbCLkZNDQsBE4u6Km0wQtpjEhXvr2boYuTiEBJYx
	Sqy/uBHI4QAr+r5bD6RGSGA6o8TTs9UQNb8ZJe613wdrZhNQk/jy5TA7iC0iECyxtOcJK0gR
	s8BrZol791+wQHS0sUism3uBDaSKE6jq2NMbzCC2sICzxOUZS8C6WQRUJW5dfAw2lVfAVmLp
	lE9sELagxI/J91hAbGYBdYlJ8xYxQ9jyEpvXvGWGuFRd4tFfXYgjjCROn5zMBFEiIrHvxTtG
	kBskBNZySLyYMJkRYpeAxLfJh1ggemUlNh1ghoSEpMTBFTdYJjBKzEKyeRaSzbOQbJ6FZMUC
	RpZVjKKpBckFxUnpRaZ6xYm5xaV56XrJ+bmbGCFJYeIOxvsHrA8xJgOtn8gsJZqcD0wqeSXx
	hsZmRhamJqbGRuaWZqQJK4nzpj9KChISSE8sSc1OTS1ILYovKs1JLT7EyMTBKdXAyP9Q/eva
	RUmbTjdcrY2q9vs1ce7v19ekw14GXQ/6Ici9+d3VgL1FV3b+EZn989pjpSC1zfPWTMp+p9NY
	d3nv9/ir8zY/fhrlee270jWtD8c85xz4v+9OZOD9Lo2rQg3GrjxvM7yNYiVFZTa55Bw1jDhz
	4+v2k7mTX6Q6M0+/Nzu3zv7XPDbbY1uUWIozEg21mIuKEwGBQnkEIAMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrFKsWRmVeSWpSXmKPExsVy+t9jQd2mi6HBBr9mMVkcvF9vMf/IOVaL
	tisH2S2aF69ns7i88BKrxY/XF9gsehdcZbO48LSHzWLT42usFgvblrBYXN41h81ixvl9TBaL
	lrUyW8z7vJPJYv2M1ywO/B47Z91l99g/dw27x+Yl9R59W1Yxehy/sZ3J4/MmuQC2qAZGm4zU
	xJTUIoXUvOT8lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE3FRbJRefAF23zBygk5UUyhJzSoFC
	AYnFxUr6dpgmhIa46VrANEbo+oYEwfUYGaCBhHWMGYcOn2YreCdWMWH/csYGxm+CXYwcHBIC
	JhLfd+t1MXICmWISF+6tZwOxhQSmM0o8PVvdxcgFZP9mlLjXfp8JJMEmoCbx5cthdhBbRCBY
	YmnPE1aQImaB18wS9+6/YIHoaGORWDf3AtgoTqCqY09vMIPYwgLOEpdnLAHrZhFQlbh18THY
	VF4BW4mlUz6xQdiCEj8m32MBsZkF1CUmzVvEDGHLS2xe85YZ4mp1iUd/dSGOMJI4fXIyE0SJ
	iMS+F+8YJzAKzUIyaRaSSbOQTJqFpGUBI8sqRtHUguSC4qT0XCO94sTc4tK8dL3k/NxNjOCU
	80x6B+OqBotDjAIcjEo8vBIGocFCrIllxZW5hxglOJiVRHilDwOFeFMSK6tSi/Lji0pzUosP
	MSYDPTqRWUo0OR+YDvNK4g2NTcyMLI3MLIxMzM1JE1YS5z3Yah0oJJCeWJKanZpakFoEs4WJ
	g1OqgTGH+9/xv4H6F/Yvff9EJtrlw4nVjeGf1A8Uzit4sc8u/NxhS+Mv1WuTOb9fq9/we0pW
	dufiO302f/Os3lXfbShavanbzuGeanZ12En9HJulZyesuMroIaP2QbJfOTK63FZh5/7b82xP
	Rfp6vJpk+aDl449zM6c0FWf+WzBt1vfPrPfrnGt8hWWVWIozEg21mIuKEwFjRzwvfQMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, April 16, 2014 11:49 PM, Vivek Gautam wrote:
> On Wed, Apr 16, 2014 at 7:14 PM, Tomasz Figa <t.figa@samsung.com> wrote:
> > On 15.04.2014 08:09, Vivek Gautam wrote:
> >> On Thu, Apr 10, 2014 at 5:09 PM, Vivek Gautam wrote:
> >>> On Wed, Apr 9, 2014 at 7:03 PM, Tomasz Figa <t.figa@samsung.com> wrote:
> >>>> On 09.04.2014 13:49, Vivek Gautam wrote:
> >>>
> >>> So, USB30_SCLK_100M is the SCLK that we are talking in the driver. I
> >>> don't see any reference to XXTI in the USB 3.0 DRD controller chapter
> >>> (in both Exynos5250 and 5420)
> >>> In addition to this there's one more point to be noticed here.
> >>> On Exynos5420 system, the sclk_usbphy300 (which is the sclk_usbphy30
> >>> for USB DRD channel 0), is also the PICO phy clock, i.e. USB 2.0 phy
> >>> clock.
> >>> So we should add a similar clk_get() for this clock in the
> >>> phy-exynos5250-usb2 driver too, to support Exynos5420.
> >>
> >>
> >> Is something clear from the above block diagram ? (although the
> >> diagram looks weird - space and tabs problem :-(  )
> >> Basically there's the clock USB30_SCLK_100M which is going into the
> >> USB 3.0 DRD PHY controller.
> >> And this is the only sclk mentioned in the block diagram for USB 3.0
> >> DRD controller in Exynos5420.
> >> Same is not there in the block diagram in Exynos5250 UM.
> >
> >
> > From what I can see in the documentation, there are 4 USB 3.0 related clocks
> > generated in CMU:
> >
> >  - sclk_usbphy300,
> >  - sclk_usbphy301,
> >  - sclk_usbdrd300,
> >  - sclk_usbdrd301,
> >
> > They are all rated to max. 24 MHz and the recommended operating frequency is
> > 24 MHz, so it looks exactly like USB PHY reference, which is usually a 24
> > MHz clock.
> >
> > To me, this looks like on Exynos5420 a separate special clock path is used
> > instead of xusbxti as reference of USB 3.0 PHY and so the sclk should be
> > simply passed as the "ref" clock.
> 
> Ok, i will clear on this with the hardware engineer also once.
> May be Jingoo can help me with this.
> 
> Jingoo,
> Can you please enquire about the clock path of usbphy30 reference
> clocks on Exynos5420.
> As mentioned by Tomasz above, we have sclk_usbphy300 and
> sclk_usbphy301 as the reference clocks for USB3.0 DRD phy. *Also*
> sclk_usbphy300 is used for Pico phy (which is the USb 2.0 phy used by
> ehci/ohci controller on Exynos5420).
> It will be of great help.

Hi Vevek, Tomasz

Long time no see.

I asked USB S/W engineer and USB H/W engineer.

There are two USB3.0 on Exynos5420; thus there are two sclks
such as 'sclk_usbphy300 and sclk_usbphy301'.

As Tomasz mentioned, 'sclk_usbphy300 and sclk_usbphy301' can
be used instead of 'xusbxti' as reference of USB 3.0 PHY.

However, on Exynos5420, "ONLY" 'sclk_usbphy300' can be used
for USB2.0 pico phy. (so, '301' CANNOT support USB2.0 pico phy.)

Best regards,
Jingoo Han

