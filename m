Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753607Ab3A3EIR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 23:08:17 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:60815 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753048Ab3A3EIO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 23:08:14 -0500
X-AuditID: cbfee61a-b7f7d6d000000f4e-78-51089cac0665
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Sachin Kamat'" <sachin.kamat@linaro.org>,
        "'Linus Walleij'" <linus.walleij@linaro.org>
Cc: "'LKML'" <linux-kernel@vger.kernel.org>,
        "'linux-samsung-soc'" <linux-samsung-soc@vger.kernel.org>
References: <CAK9yfHybC6ZgGwxa_i=LrMpU_q9M4aaMraTqK63B+fw11NBqRA@mail.gmail.com>
 <CACRpkdYj_e6+iT7iAVtA8_t=4e_2Lxo9duozXccfcbKY8fGk7A@mail.gmail.com>
 <CAK9yfHwav_u3mjVqNdX4kY=LyUW30vr6AMGUExfGKuJn2KH8qQ@mail.gmail.com>
In-reply-to: <CAK9yfHwav_u3mjVqNdX4kY=LyUW30vr6AMGUExfGKuJn2KH8qQ@mail.gmail.com>
Subject: RE: Failure due to missing (Exynos related) pinctrl patch
Date: Tue, 29 Jan 2013 20:08:07 -0800
Message-id: <076401cdfe9f$6a0f5fa0$3e2e1ee0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQIQEhSOcfF2dxL6YkpdblpHwBx89AG99RD/AcyKy5mXwMYIgA==
Content-language: en-us
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrMIsWRmVeSWpSXmKPExsVy+t8zfd01czgCDbpbrCwu75rDZjHj/D4m
	ByaPz5vkAhijuGxSUnMyy1KL9O0SuDJ+L4ks2MxWcePXE6YGxhbWLkZODgkBE4l18xYxQ9hi
	EhfurWfrYuTiEBJYxijxZP1XdpiimwfXMYLYQgLTGSVOHwuBKPrLKLF1/X+wbjYBDYnD75+B
	NYgIREl8ampkAbGZBVIk3mz7CTX1AaPE1E0fwFZzCgRL7Fi6ngnEFhZwktj18gnYBhYBVYmr
	946BDeUVsJR4cvIOC4QtKPFj8j2ooVoS63ceZ4Kw5SU2r3kL9YKCxI6zrxkhjnCSeHPzNFS9
	uMSkBw/ZQY6QEFjGLvF6/is2iGUCEt8mHwIq4gBKyEpsOgA1R1Li4IobLBMYJWYhWT0LyepZ
	SFbPQrJiASPLKkbR1ILkguKk9FxDveLE3OLSvHS95PzcTYyQKJPawbiyweIQowAHoxIP74IX
	7IFCrIllxZW5hxglOJiVRHgV1DgChXhTEiurUovy44tKc1KLDzEmAx07kVlKNDkfmADySuIN
	jY1NzExMTcwtTc1NSRNWEudlPPUkQEggPbEkNTs1tSC1CGYLEwenVANjJk8S7+KvbH+c7lhe
	nm3Odo3zCdPCLRM3rl+257pG6qNTS9bNfb51olHSnrCDmy82bwy4JC05Id7h2962/epTuHR2
	mEeInVV4Ycir0vUsWF3eaMuPBknWiT9CC60e85npRT3/fi6A6X3CDxMGsbMNB/h98pMmTZst
	wOu33ePLNo8tGW7VFjejlViKMxINtZiLihMBqLBFBPYCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprEKsWRmVeSWpSXmKPExsVy+t9jQd01czgCDQ7OMbO4vGsOm8WM8/uY
	HJg8Pm+SC2CMamC0yUhNTEktUkjNS85PycxLt1XyDo53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ
	0HXLzAEaraRQlphTChQKSCwuVtK3wzQhNMRN1wKmMULXNyQIrsfIAA0krGPM+L0ksmAzW8WN
	X0+YGhhbWLsYOTkkBEwkbh5cxwhhi0lcuLeeDcQWEpjOKHH6WEgXIxeQ/ZdRYuv6/8wgCTYB
	DYnD75+xg9giAlESn5oaWUBsZoEUiTfbfrJBNDxglJi66QPYBk6BYIkdS9czgdjCAk4Su14+
	AdvGIqAqcfXeMbChvAKWEk9O3mGBsAUlfky+BzVUS2L9zuNMELa8xOY1b5khLlWQ2HH2NSPE
	EU4Sb26ehqoXl5j04CH7BEahWUhGzUIyahaSUbOQtCxgZFnFKJpakFxQnJSea6hXnJhbXJqX
	rpecn7uJERzDz6R2MK5ssDjEKMDBqMTDu+AFe6AQa2JZcWXuIUYJDmYlEV4FNY5AId6UxMqq
	1KL8+KLSnNTiQ4zJQJ9OZJYSTc4Hppe8knhDYxMzI0sjMwsjE3Nz0oSVxHkZTz0JEBJITyxJ
	zU5NLUgtgtnCxMEp1cDIX150Nsul2Ei0va/q/FFXDoa25zf3c+zZvCz/UYXGFSe3K8Gp10J3
	C3E9ke7NO1RW/qY5/YyRhPp+2Q2siz/G2n8oFOReoS8TzP1y+Wkng+dhk1xN+z5YHVjYVRzp
	eGsHw22/iH/urKuU24V3O9lYiOocm2JwsHvuXz45rj3b+U6I3fQ7k6fEUpyRaKjFXFScCADt
	jF7NJQMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sachin Kamat wrote:
> 
> >> This patch is required along with the
> >> patch "gpio: samsung: fix pinctrl condition for exynos and exynos5440"
> >> (mainline commit Id: e4a5da51) which has already made it into
> >> mainline. Without the missing patch we get the following boot up
> >> warnings and subsequent failures with dt boot on 4412 based board:
> >
> > Hm I didn't realize there was a dependency between these
> > patches, oh well, better get the pull for the pinctrl tree finished
> > off then...
> 
> Ideally those 2 patches should have been squashed together.
> 
Err, Sachin, what are you talking about? As you said, one patch has been
merged into the mainline, so how does it can be squashed? In this case, just
applying the other patch into pinctrl-fixes is enough.

Thanks.

- Kukjin

