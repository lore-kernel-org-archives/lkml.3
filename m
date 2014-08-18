Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751860AbaHRBeL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2014 21:34:11 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:17259 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751666AbaHRBeI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2014 21:34:08 -0400
X-AuditID: cbfee68d-b7f2f6d0000062f0-d6-53f1580d5051
From: Jingoo Han <jg1.han@samsung.com>
To: "'Vivek Gautam'" <gautam.vivek@samsung.com>,
        "'Felipe Balbi'" <balbi@ti.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, grant.likely@linaro.org,
        gregkh@linuxfoundation.org, stern@rowland.harvard.edu,
        s.nawrocki@samsung.com, k.debski@samsung.com,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <1408026240-28365-1-git-send-email-gautam.vivek@samsung.com>
 <1408026240-28365-2-git-send-email-gautam.vivek@samsung.com>
In-reply-to: <1408026240-28365-2-git-send-email-gautam.vivek@samsung.com>
Subject: Re: [PATCH 1/7] usb-phy: samsung-usb3: Remove older phy-samsung-usb3
 driver
Date: Mon, 18 Aug 2014 10:34:05 +0900
Message-id: <009e01cfba84$7f795060$7e6bf120$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac+3y3Gm+ObsG4xvRLy94b2CAP7QRwCuKeAw
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrBIsWRmVeSWpSXmKPExsVy+t8zI13eiI/BBhs2WlgcvF9vMf/IOVaL
	tisH2S0O/NnBaNG8eD2bxeWFl1gtfry+AGTtmsNmsWhZK7PF4TftrBYTfl9gc+D2uHNtD5vH
	/rlr2D1m3/3B6NG3ZRWjx/Eb25k8Pm+SC2CL4rJJSc3JLEst0rdL4MpY9WA3S8Fi1oodl0sa
	GCezdDFyckgImEjce9/MCGGLSVy4t56ti5GLQ0hgGaPEnMcv2bsYOcCK2iayQ8SnM0osOb+B
	GcL5zSjxdMtTNpBuNgE1iS9fDoM1iAj4SMzbHghSwyzwn1Hi7p0HLBAN7UANb3tYQRo4BTwl
	7t+6xwLSICwQJvHqZjBImEVAVWLCxG9g1/EK2Er0du1kgrAFJX5MvgcWZxbQkli/8zgThC0v
	sXnNW2aIQ9UlHv3VBQmLCBhJHNx0lRmiRERi34t3jCAnSAj0ckhsuvqGHWKXgMS3yYdYIHpl
	JTYdYIYEhKTEwRU3WCYwSsxCsnkWks2zkGyehWTFAkaWVYyiqQXJBcVJ6UWGesWJucWleel6
	yfm5mxghsd67g/H2AetDjMlA6ycyS4km5wNTRV5JvKGxmZGFqYmpsZG5pRlpwkrivEkPk4KE
	BNITS1KzU1MLUovii0pzUosPMTJxcEo1MPoncrP4uZ2ZxXXspoDHstdX98dPe8u2NlX79vmD
	We6Vs+fbsMtPc+E7tPLX5cU+US4Zfz8Lfff0+XbRZWFmmUOespzxh9Qlp95KBT5avrtihuTq
	yOLk6MuNb7ewaGpsSd0YNu16S4+UlXeucNvvyKdW6qKSbzPaH5q+/uP+bO3+1T1/39Y7HVZi
	Kc5INNRiLipOBACzrnxACwMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrOKsWRmVeSWpSXmKPExsVy+t9jQV3eiI/BBu+2GlscvF9vMf/IOVaL
	tisH2S0O/NnBaNG8eD2bxeWFl1gtfry+AGTtmsNmsWhZK7PF4TftrBYTfl9gc+D2uHNtD5vH
	/rlr2D1m3/3B6NG3ZRWjx/Eb25k8Pm+SC2CLamC0yUhNTEktUkjNS85PycxLt1XyDo53jjc1
	MzDUNbS0MFdSyEvMTbVVcvEJ0HXLzAG6T0mhLDGnFCgUkFhcrKRvh2lCaIibrgVMY4Sub0gQ
	XI+RARpIWMeYserBbpaCxawVOy6XNDBOZuli5OCQEDCRaJvI3sXICWSKSVy4t56ti5GLQ0hg
	OqPEkvMbmCGc34wST7c8ZQOpYhNQk/jy5TA7SLOIgI/EvO2BIDXMAv8ZJe7eecAC0dAO1PC2
	hxWkgVPAU+L+rXtg24QFwiRe3QwGCbMIqEpMmPiNBcTmFbCV6O3ayQRhC0r8mHwPLM4soCWx
	fudxJghbXmLzmrfMEEerSzz6qwsSFhEwkji46SozRImIxL4X7xgnMArNQjJpFpJJs5BMmoWk
	ZQEjyypG0dSC5ILipPRcQ73ixNzi0rx0veT83E2M4ETyTGoH48oGi0OMAhyMSjy8Hq8/BAux
	JpYVV+YeYpTgYFYS4b0UABTiTUmsrEotyo8vKs1JLT7EaAr06ERmKdHkfGCSyyuJNzQ2MTOy
	NDKzMDIxN1cS5z3Qah0oJJCeWJKanZpakFoE08fEwSnVwDgh9sevqxe4DwbXnOM2tfWYePmm
	3l8PBv6+HfeuGr38cFq5RtbnzN/SVc+7Z5pdenQ6XPz5r3l7bqQcd+AvDT3YUJu5gsfgjvRd
	Y7ez+apNCq0bV0/8rJvE5HQoedZf65dnLnidWzn54f897SfCtgtuVOHdZzv5t8SN5ceenKn/
	/EKG/cjt/rUKSizFGYmGWsxFxYkAz/2/LzoDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, August 14, 2014 11:24 PM, Vivek Gautam wrote:
> 
> Removing this older USB 3.0 DRD controller PHY driver, since
> a new driver based on generic phy framework is now available.
> 
> Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>

Reviewed-by: Jingoo Han <jg1.han@samsung.com>

Best regards,
Jingoo Han

> ---
>  drivers/usb/phy/Kconfig            |    8 -
>  drivers/usb/phy/Makefile           |    1 -
>  drivers/usb/phy/phy-samsung-usb.h  |   80 ---------
>  drivers/usb/phy/phy-samsung-usb3.c |  350 ------------------------------------
>  4 files changed, 439 deletions(-)
>  delete mode 100644 drivers/usb/phy/phy-samsung-usb3.c

