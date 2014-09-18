Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757573AbaIRD1R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 23:27:17 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:19581 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757282AbaIRD1P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 23:27:15 -0400
X-AuditID: cbfee68d-f79c46d000000b84-43-541a5111528b
From: Pankaj Dubey <pankaj.dubey@samsung.com>
To: "'Arnd Bergmann'" <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, lee.jones@linaro.org,
        tomasz.figa@gmail.com, linux@arm.linux.org.uk,
        vikas.sajjan@samsung.com, joshi@samsung.com, naushad@samsung.com,
        thomas.ab@samsung.com, chow.kim@samsung.com, kgene.kim@samsung.com,
        "'Dong Aisheng'" <b29396@freescale.com>
References: <1410935510-1567-1-git-send-email-pankaj.dubey@samsung.com>
 <201409171723.04549.arnd@arndb.de>
In-reply-to: <201409171723.04549.arnd@arndb.de>
Subject: RE: [PATCH v3] mfd: syscon: Decouple syscon interface from platform
 devices
Date: Thu, 18 Sep 2014 08:59:32 +0530
Message-id: <000001cfd2f0$c9d0ebd0$5d72c370$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQGAgvNtQpXjUZMClJmM9wWnjoVNAgHw7BRGnJVSGvA=
Content-language: en-us
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrCIsWRmVeSWpSXmKPExsWyRsSkWlcwUCrEYOUiQYu/k46xWzzc2c9i
	sWzSXTaL77u+sFv0LrjKZnH/61FGi02Pr7FaXN41h81ixvl9TBa3L/NafDr6n9WiYxmjxapd
	fxgtbj7bzuTA59HS3MPm8fvXJEaPf4f7mTx2zrrL7nHn2h42j81L6j36tqxi9Pi8SS6AI4rL
	JiU1J7MstUjfLoErY0KrXcEWnore6/fYGxgvcnYxcnBICJhITPga2cXICWSKSVy4t56ti5GL
	Q0hgKaPE2RX3GSESJhJnnk1jhUgsYpRYOnMuE4Tzl1Git/cWG0gVm4CuxJP3c5lBbBEBZYnj
	L++wgNjMAo+ZJK48rAXZJiSQI7FxjhtImFNAX+LtvPdg5cICYRJXe8+zg9gsAqoS3YsOM4HY
	vAKWQMd9ZIewBSV+TL4HNVJLYv3O40wQtrzE5jVvmSEOVZDYcfY1I8QJVhINr7pZIWrEJSY9
	eMgOcrOEwEoOiX0b9rFBLBOQ+Db5EAskJGQlNh2AmiMpcXDFDZYJjBKzkKyehWT1LCSrZyFZ
	sYCRZRWjaGpBckFxUnqRoV5xYm5xaV66XnJ+7iZGYGI4/e9Z7w7G2wesDzEKcDAq8fAe4JUK
	EWJNLCuuzD3EaAp00URmKdHkfGD6ySuJNzQ2M7IwNTE1NjK3NFMS51WU+hksJJCeWJKanZpa
	kFoUX1Sak1p8iJGJg1OqgfH4pn37/sy+pmfVy9uf4OnuX9T24wyPbO77nQa2XSwS3N/TE888
	O8/o5cUimXv6rKXT/c4SE8edn9Ob3584++3uJvfD0lsOuBreWqC54Fwli5nfyw9zV6V1HFaV
	6Vi+Wvw6p8CWhyxxcmyejp2e1W/d3ko8vHvbbsL1ywH1wTlTPibY1J/nmqLEUpyRaKjFXFSc
	CABgF63fBwMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrPKsWRmVeSWpSXmKPExsVy+t9jAV3BQKkQgyVv2C3+TjrGbvFwZz+L
	xbJJd9ksvu/6wm7Ru+Aqm8X9r0cZLTY9vsZqcXnXHDaLGef3MVncvsxr8enof1aLjmWMFqt2
	/WG0uPlsO5MDn0dLcw+bx+9fkxg9/h3uZ/LYOesuu8eda3vYPDYvqffo27KK0ePzJrkAjqgG
	RpuM1MSU1CKF1Lzk/JTMvHRbJe/geOd4UzMDQ11DSwtzJYW8xNxUWyUXnwBdt8wcoLOVFMoS
	c0qBQgGJxcVK+naYJoSGuOlawDRG6PqGBMH1GBmggYQ1jBkTWu0KtvBU9F6/x97AeJGzi5GT
	Q0LAROLMs2msELaYxIV769m6GLk4hAQWMUosnTmXCcL5yyjR23uLDaSKTUBX4sn7ucwgtoiA
	ssTxl3dYQGxmgcdMElce1nYxcgA15EhsnOMGEuYU0Jd4O+89WLmwQJjE1d7z7CA2i4CqRPei
	w0wgNq+ApcSErx/ZIWxBiR+T70GN1JJYv/M4E4QtL7F5zVtmiEMVJHacfc0IcYKVRMOrblaI
	GnGJSQ8esk9gFJqFZNQsJKNmIRk1C0nLAkaWVYyiqQXJBcVJ6blGesWJucWleel6yfm5mxjB
	ieeZ9A7GVQ0WhxgFOBiVeHgP8EqFCLEmlhVX5h5ilOBgVhLhzfMFCvGmJFZWpRblxxeV5qQW
	H2I0Bfp0IrOUaHI+MCnmlcQbGpuYmxqbWppYmJhZKonzHmy1DhQSSE8sSc1OTS1ILYLpY+Lg
	lGpgjLj9prllnnBY6CWtGvXypRue7zxVubIuqDFGoTlmU8E5pU8z0/ISn92xmNv9pJ/7jJmU
	fc3XCTuTr1WKKWR7Ncu7WEV2zVjftknj499likuUwl6+Cy6Vn272dLJmnOU75peX3TK4A/4l
	rtz54ErshQ8nTkwQX/t6KbdX0V6eNX3rPi7bJNnFqcRSnJFoqMVcVJwIAE9F7YhSAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

+CC: Dong Aisheng 

Hi Arnd,

On Wednesday, September 17, 2014, Arnd Bergmann wrote,
> > V2 of this patchset and related discussion can be found here [1].
> >
> > Changes since v2:
> >  - Added back platform device support from syscon, with one change that
> >    syscon will not be probed for DT based platform.
> >  - Added back syscon_regmap_lookup_by_pdevname API so that non-DT base
> >    users of syscon will not be broken.
> >  - Removed unwanted change in syscon.h.
> >  - Modified Signed-off-by list, added Suggested-by of Tomasz Figa and
> >    Arnd Bergmann.
> >  - Added Tested-by of Vivek Gautam for testing on Exynos platform.
> 
> Looks fine. Provided you can figure out the problem that Dong Aisheng
reported,
> please add my
> 
> Acked-by: Arnd Bergmann <arnd@arndb.de>
>

Thanks. 
After he reported I have again done code walk-through of regmap_init_mmio
and 
could not see any such fatal error.  At the same time I have replied to Dong
Aisheng,
asking for more details and waiting for his reply. 
 
> > -}
> > +static struct syscon *of_syscon_register(struct device_node *np);
> >
> 
> One  minor comment: please avoid doing forward declarations of local
functions. It
> took me a while to understand what is going on because I expect all
functions to be
> ordered such that they only get called by functions below, and don't need
this.
> 
> Just move of_syscon_register() here directly.
> 

OK, I will remove forward declaration of "of_syscon_register" and respin
patch once again.

> 	Arnd

Thanks,
Pankaj Dubey

