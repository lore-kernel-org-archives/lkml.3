Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754620Ab3GYBzl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 21:55:41 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:22524 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754247Ab3GYBzj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 21:55:39 -0400
X-AuditID: cbfee68f-b7f436d000000f81-76-51f0859ac8de
From: Jingoo Han <jg1.han@samsung.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "'Kim, Milo'" <Milo.Kim@ti.com>, rpurdie@rpsys.net,
        linux-kernel@vger.kernel.org, Jingoo Han <jg1.han@samsung.com>
References: <A874F61F95741C4A9BA573A70FE3998F82E808C2@DQHE06.ent.ti.com>
 <004e01ce80f7$fd21eee0$f765cca0$@samsung.com>
In-reply-to: <004e01ce80f7$fd21eee0$f765cca0$@samsung.com>
Subject: Re: [PATCH re-send] backlight: lp855x_bl: support new LP8555 device
Date: Thu, 25 Jul 2013 10:55:38 +0900
Message-id: <000801ce88da$0f68fd70$2e3af850$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQHDjJrPeNF3w9CKkdypNROV2RzLIwIqPaWTmXlIM0A=
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrOIsWRmVeSWpSXmKPExsVy+t8zQ91ZrR8CDSZuUrWYs34Nm8XlhZdY
	LS7vmsNmsfzXOhaL3buesjqwepyY8ZvFY8/8H6wefVtWMXocv7GdyePzJrkA1igum5TUnMyy
	1CJ9uwSujENnlrMX7Oaq2N53lK2BsZGji5GDQ0LAROLV3tguRk4gU0ziwr31bF2MXBxCAssY
	JaYvfMAKkTCRePTmJStEYjqjROftbiYI5xejxLyl/YwgVWwCahJfvhxmB7FFBHQlVj3fxQyy
	gVmgQqL1LjdIWAjIfDzzLROIzSlgJfHr2F0WEFtYwEfi48JtzCA2i4CqxLR7x9hAbF4BS4md
	MzcxQ9iCEj8m3wOrZxbQkli/8zgThC0vsXnNW2aIQxUkdpx9zQhxgpXE34UzoepFJPa9eMcI
	crOEwD12iY3bl0EtE5D4NvkQCyQkZCU2HYCaIylxcMUNlgmMErOQrJ6FZPUsJKtnIVmxgJFl
	FaNoakFyQXFSepGxXnFibnFpXrpecn7uJkZIpPbvYLx7wPoQYzLQ+onMUqLJ+cBIzyuJNzQ2
	M7IwNTE1NjK3NCNNWEmcV63FOlBIID2xJDU7NbUgtSi+qDQntfgQIxMHp1QDo1XOjPNJbUmv
	fzVP64k9zX3wpNAatRnzf1jrz5okavnGI2zjkTbX4l9vdQRjMlLFGKTL/TR1dTs3+p0K+X5/
	2r08RyXDcJ5T8/q1+TKPG/1xbBOQjrVqjGNyvdw9V0pimU/LkSV8Xavutwvs15722+f4pI06
	c3lvCPyLei6wREqj/6PExjddSizFGYmGWsxFxYkATftyxuoCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrKKsWRmVeSWpSXmKPExsVy+t9jQd1ZrR8CDSYvU7SYs34Nm8XlhZdY
	LS7vmsNmsfzXOhaL3buesjqwepyY8ZvFY8/8H6wefVtWMXocv7GdyePzJrkA1qgGRpuM1MSU
	1CKF1Lzk/JTMvHRbJe/geOd4UzMDQ11DSwtzJYW8xNxUWyUXnwBdt8wcoO1KCmWJOaVAoYDE
	4mIlfTtME0JD3HQtYBojdH1DguB6jAzQQMI6xoxDZ5azF+zmqtjed5StgbGRo4uRk0NCwETi
	0ZuXrBC2mMSFe+vZuhi5OIQEpjNKdN7uZoJwfjFKzFvazwhSxSagJvHly2F2EFtEQFdi1fNd
	zF2MHBzMAhUSrXe5QcJCQObjmW+ZQGxOASuJX8fusoDYwgI+Eh8XbmMGsVkEVCWm3TvGBmLz
	ClhK7Jy5iRnCFpT4MfkeWD2zgJbE+p3HmSBseYnNa94yQxyqILHj7GtGiBOsJP4unAlVLyKx
	78U7xgmMQrOQjJqFZNQsJKNmIWlZwMiyilE0tSC5oDgpPddIrzgxt7g0L10vOT93EyM4ETyT
	3sG4qsHiEKMAB6MSD++K7+8DhVgTy4orcw8xSnAwK4nwxlZ8CBTiTUmsrEotyo8vKs1JLT7E
	mAz06URmKdHkfGCSyiuJNzQ2MTOyNDKzMDIxNydNWEmc92CrdaCQQHpiSWp2ampBahHMFiYO
	TqkGxs1iQYuLdv+b/HinDPfT5IXxPaIyVjHXAtsMRX4uvTv5yAelkOiSS4UJ8/2EzY4oKs79
	4B4bIcu35sZi/UYvkSrVrT8URSXLhWO2VG8U1/7t92hLurN+eSDfgSj7UNXbph9Prg67OyPN
	ZNKZjlkJ8vO3vJZY8yOtIj79BadMdT3Hu7dnXu17rMRSnJFoqMVcVJwIAGVxGU9IAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, July 15, 2013 10:10 AM, Jingoo Han wrote:
> On Tuesday, July 09, 2013 6:12 PM, Kim, Milo wrote:
> >
> > LP8555 is one of LP855x family device.
> > This device needs pre_init_device() and post_init_device() driver structure.
> > It's same as LP8557, so the device configuration code is shared with LP8557.
> > Backlight outputs are generated from dual DC-DC boost converters.
> > It's configurable EPROM settings which are defined in the platform data.
> >
> > Driver documentation and device tree bindings are updated.
> >
> > Signed-off-by: Milo Kim <milo.kim@ti.com>
> 
> It looks good.
> Acked-by: Jingoo Han <jg1.han@samsung.com>

Hi Andrew Morton,

There is not git tree for backlight subsystem yet.
Could you take this patch into mm-tree with my ACK?
Thank you.

Best regards
Jingoo Han

> > ---
> > This patch is re-sent with additional Cc lists.
> >
> >  Documentation/backlight/lp855x-driver.txt          |    5 ++--
> >  .../devicetree/bindings/video/backlight/lp855x.txt |   29 +++++++++++++++++++-
> >  drivers/video/backlight/Kconfig                    |    4 +--
> >  drivers/video/backlight/lp855x_bl.c                |   17 ++++++++++--
> >  include/linux/platform_data/lp855x.h               |   19 +++++++++++++
> >  5 files changed, 67 insertions(+), 7 deletions(-)
> >


