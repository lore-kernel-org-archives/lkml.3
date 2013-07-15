Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753750Ab3GOBJq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jul 2013 21:09:46 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:16280 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753663Ab3GOBJp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jul 2013 21:09:45 -0400
X-AuditID: cbfee68d-b7f096d0000043fc-5d-51e34bd7d053
From: Jingoo Han <jg1.han@samsung.com>
To: "'Kim, Milo'" <Milo.Kim@ti.com>, akpm@linux-foundation.org
Cc: rpurdie@rpsys.net, linux-kernel@vger.kernel.org,
        Jingoo Han <jg1.han@samsung.com>
References: <A874F61F95741C4A9BA573A70FE3998F82E808C2@DQHE06.ent.ti.com>
In-reply-to: <A874F61F95741C4A9BA573A70FE3998F82E808C2@DQHE06.ent.ti.com>
Subject: Re: [PATCH re-send] backlight: lp855x_bl: support new LP8555 device
Date: Mon, 15 Jul 2013 10:09:43 +0900
Message-id: <004e01ce80f7$fd21eee0$f765cca0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQHDjJrPeNF3w9CKkdypNROV2RzLI5l61m6Q
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrBIsWRmVeSWpSXmKPExsVy+t8zfd3r3o8DDRqb1SzmrF/DZnF54SVW
	i8u75rBZLP+1jsVi966nrA6sHidm/Gbx2DP/B6tH35ZVjB7Hb2xn8vi8SS6ANYrLJiU1J7Ms
	tUjfLoErY+HGHawF5zkq/h+dzdrAeJmti5GTQ0LARGLx9dusELaYxIV764HiXBxCAssYJd7O
	vc4KU/T75TlWiMQiRomda7dDVf1ilHjwaj4jSBWbgJrEly+H2UFsEQE7iV1H9rCA2MwC4RJL
	Pq9iBrGFBDwkLnQ9A2rm4OAU8JTo2loNEhYW8JH4uHAbWAmLgKrE7EOrwFp5BSwlXhy4yAhh
	C0r8mHwPaqSWxOZtTawQtrzE5jVvmSEOVZDYcfY1I8QJRhKz+xYxQdSISOx78Y4R5GYJgVvs
	EndubGeDWCYg8W3yIRaQeyQEZCU2HYCaIylxcMUNlgmMErOQrJ6FZPUsJKtnIVmxgJFlFaNo
	akFyQXFSepGhXnFibnFpXrpecn7uJkZIrPbuYLx9wPoQYzLQ+onMUqLJ+cBYzyuJNzQ2M7Iw
	NTE1NjK3NCNNWEmcV63FOlBIID2xJDU7NbUgtSi+qDQntfgQIxMHp1QDo1aM6OS7kzd0tIu+
	qpjSYmi+fMtHTdtntlYX1natNgtYlaupphS3cLejU+rpioLJ8oe87v25o6vtfbj7beVjF69z
	5ly6XNrX577lO/c4ie1V6IywtqY1D5o37J9nv5u3V9XuuZ/NCs6yZ6E7+GukC2by/oxnujNF
	fV+l8667n1pmWrtxrZBbr8RSnJFoqMVcVJwIAHpN4IXrAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrKKsWRmVeSWpSXmKPExsVy+t9jAd3r3o8DDQ7NVrKYs34Nm8XlhZdY
	LS7vmsNmsfzXOhaL3buesjqwepyY8ZvFY8/8H6wefVtWMXocv7GdyePzJrkA1qgGRpuM1MSU
	1CKF1Lzk/JTMvHRbJe/geOd4UzMDQ11DSwtzJYW8xNxUWyUXnwBdt8wcoO1KCmWJOaVAoYDE
	4mIlfTtME0JD3HQtYBojdH1DguB6jAzQQMI6xoyFG3ewFpznqPh/dDZrA+Nlti5GTg4JAROJ
	3y/PsULYYhIX7q0HinNxCAksYpTYuXY7lPOLUeLBq/mMIFVsAmoSX74cZgexRQTsJHYd2cMC
	YjMLhEss+byKGcQWEvCQuND1DKiZg4NTwFOia2s1SFhYwEfi48JtYCUsAqoSsw+tAmvlFbCU
	eHHgIiOELSjxY/I9qJFaEpu3NbFC2PISm9e8ZYY4VEFix9nXjBAnGEnM7lvEBFEjIrHvxTvG
	CYxCs5CMmoVk1Cwko2YhaVnAyLKKUTS1ILmgOCk910ivODG3uDQvXS85P3cTIzgRPJPewbiq
	weIQowAHoxIPb4ba40Ah1sSy4srcQ4wSHMxKIrzLlB8FCvGmJFZWpRblxxeV5qQWH2JMBvp0
	IrOUaHI+MEnllcQbGpuYGVkamVkYmZibkyasJM57sNU6UEggPbEkNTs1tSC1CGYLEwenVAOj
	hODHdbwuG09cU5wnMsGweeqKgx/+Os96eWPdw8Q2hUqexVwP1jhPKG1lrubadzRQ1Tq0SkZk
	Y7j2Fa+wILf4q637WPqUs07onvcyMzA/ZWqvKHLre0fF6ny12847RdQ/yenf8jy0eLXKvNCt
	x5zLbh08PGvJCu+wzM+Pim8dCX141Of2Q5MSJZbijERDLeai4kQA2Q+tPkgDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, July 09, 2013 6:12 PM, Kim, Milo wrote:
> 
> LP8555 is one of LP855x family device.
> This device needs pre_init_device() and post_init_device() driver structure.
> It's same as LP8557, so the device configuration code is shared with LP8557.
> Backlight outputs are generated from dual DC-DC boost converters.
> It's configurable EPROM settings which are defined in the platform data.
> 
> Driver documentation and device tree bindings are updated.
> 
> Signed-off-by: Milo Kim <milo.kim@ti.com>

It looks good.
Acked-by: Jingoo Han <jg1.han@samsung.com>

Best regards,
Jingoo Han

> ---
> This patch is re-sent with additional Cc lists.
> 
>  Documentation/backlight/lp855x-driver.txt          |    5 ++--
>  .../devicetree/bindings/video/backlight/lp855x.txt |   29 +++++++++++++++++++-
>  drivers/video/backlight/Kconfig                    |    4 +--
>  drivers/video/backlight/lp855x_bl.c                |   17 ++++++++++--
>  include/linux/platform_data/lp855x.h               |   19 +++++++++++++
>  5 files changed, 67 insertions(+), 7 deletions(-)
> 


