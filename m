Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754171AbaJHDBW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 23:01:22 -0400
Received: from mail-qa0-f50.google.com ([209.85.216.50]:45298 "EHLO
	mail-qa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753592AbaJHDBU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 23:01:20 -0400
MIME-Version: 1.0
In-Reply-To: <20141007141118.GD24720@saruman>
References: <1412677176-3850-1-git-send-email-gautam.vivek@samsung.com>
	<1412677176-3850-2-git-send-email-gautam.vivek@samsung.com>
	<20141007141118.GD24720@saruman>
Date: Wed, 8 Oct 2014 08:31:19 +0530
X-Google-Sender-Auth: bYW2QH6c97AbP7pb_Da2wMSRD9E
Message-ID: <CAFp+6iF9ttEGSVc9p+YSXFxKnVTGK5aqyT0nEiFXbpoXj8aW+w@mail.gmail.com>
Subject: Re: [PATCH v2 1/4] dwc3: exynos: Add support for SCLK present on Exynos7
From: Vivek Gautam <gautam.vivek@samsung.com>
To: Felipe Balbi <balbi@ti.com>
Cc: Linux USB Mailing List <linux-usb@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Mark Rutland <mark.rutland@arm.com>, Pawel Moll <pawel.moll@arm.com>,
        "robh+dt" <robh+dt@kernel.org>, kishon <kishon@ti.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 7, 2014 at 7:41 PM, Felipe Balbi <balbi@ti.com> wrote:
> On Tue, Oct 07, 2014 at 03:49:33PM +0530, Vivek Gautam wrote:
>> Exynos7 also has a separate special gate clock going to the IP
>> apart from the usual AHB clock. So add support for the same.
>>
>> Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
>
> I'll take this one once -rc1 is tagged. The others have no direct
> dependency on this so I'll leave them to Kishon.

Thanks Felipe !



-- 
Best Regards
Vivek Gautam
Samsung R&D Institute, Bangalore
India
