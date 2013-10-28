Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756794Ab3J1Nw5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 09:52:57 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:11850 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756603Ab3J1Nwx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 09:52:53 -0400
Date: Mon, 28 Oct 2013 14:52:50 +0100
From: Kamil Debski <k.debski@samsung.com>
Subject: RE: [PATCH 4/5] usb: ehci-s5p: Change to use phy provided by the
 generic phy framework
In-reply-to: <003101ced1ea$85f7e010$91e7a030$%han@samsung.com>
To: "'Jingoo Han'" <jg1.han@samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-usb@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm@vger.kernel.org,
        "'Kyungmin Park'" <kyungmin.park@samsung.com>,
        "'Kishon Vijay Abraham I'" <kishon@ti.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        "'Vivek Gautam'" <gautam.vivek@samsung.com>,
        "'Mateusz Krawczuk'" <mat.krawczuk@gmail.com>
Message-id: <025e01ced3e4$fec0de60$fc429b20$%debski@samsung.com>
MIME-version: 1.0
X-Mailer: Microsoft Office Outlook 12.0
Content-type: text/plain; charset=us-ascii
Content-language: pl
Content-transfer-encoding: 7bit
Thread-index: Ac7RjQQeA+F8IuX1Sui/BMlCS4ypRQAXGYMwAH4Nc4A=
X-AuditID: cbfec7f4-b7f0a6d000007b1b-de-526e6c331c7c
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrJLMWRmVeSWpSXmKPExsVy+t/xy7rGOXlBBgd+WVnMP3KO1aLtykF2
	i8sLL7FaXHjaw2ZxtukNu8W0nf9ZLS7vmsNmMeP8PiaLRctamS3WHrnLbnG2/zabxeE37awW
	62e8ZnHg9dg56y67R9+WVYwex29sZ/L4vEkugCWKyyYlNSezLLVI3y6BK+P1OfWCK+wVZ37e
	YG9gbGTrYuTkkBAwkbi45w4LhC0mceHeeqA4F4eQwFJGiXftm1khnAYmiSmftgI5HBxsApoS
	q+55gDSICKhJNC8/wwJSwyxwjlli3ZR37BANmxkl7jX8ZgKp4hSwk1i08T47iC0skChxZOZq
	ZhCbRUBVom/9X7AzeAUcJHbsXcQMYQtK/Jh8D+wkZgEtifU7jzNB2PISm9e8ZQY5QkJAXeLR
	X10QU0TASuLHZn6IChGJuw3PWScwCs1CMmgWkkGzkAyahaRlASPLKkbR1NLkguKk9FxDveLE
	3OLSvHS95PzcTYyQ6Pqyg3HxMatDjAIcjEo8vBvW5gYJsSaWFVfmHmKU4GBWEuGdGpcXJMSb
	klhZlVqUH19UmpNafIiRiYNTqoFR4qfp7bX77hSmznkzJcXCKW27vCn/4kbWT9UHvq9w6tk8
	bVP/9TTBuydXv8n5OcV+rUd8lruFzJct3Cs+deZasStse6F5OVjNTW7y039ZdaluhltZPq9j
	L7465aSga8Hje02nW3YaPfzhHqzm843x4ZrCpukrpEw3p07/1avuG2bMknvF8d4NJZbijERD
	Leai4kQAxO4SOIwCAAA=
References: <1382710529-12082-1-git-send-email-k.debski@samsung.com>
 <1382710529-12082-5-git-send-email-k.debski@samsung.com>
 <003101ced1ea$85f7e010$91e7a030$%han@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jingoo,

> From: Jingoo Han [mailto:jg1.han@samsung.com]
> Sent: Saturday, October 26, 2013 3:27 AM
> 
> On Friday, October 25, 2013 11:15 PM, Kamil Debski wrote:
> >
> > Change the phy provider used from the old usb phy specific to a new
> > one using the generic phy framework.
> >
> > Signed-off-by: Kamil Debski <k.debski@samsung.com>
> > Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> > ---
> >  drivers/usb/host/ehci-s5p.c |   21 +++++++++++----------
> >  1 file changed, 11 insertions(+), 10 deletions(-)
> 
> Hi Kamil Debski,
> It looks good. :-)

Thank you.
 
> However, could you re-basing against Greg's 'usb-next' branch?
> Now, the file name of 'ehci-s5p.c' is renamed to 'ehci-exynos.c'.
> Also, 'Generic PHY Framework' was already merged to Greg's 'usb-next'
> branch.

Thanks for pointing out this.

> 
> Thank you.
> 
> Best regards,
> Jingoo Han

Best wishes,
-- 
Kamil Debski
Samsung R&D Institute Poland

