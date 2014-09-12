Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751306AbaILDv7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 23:51:59 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:45354 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750976AbaILDv5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 23:51:57 -0400
X-AuditID: cbfee68d-f79c46d000000b84-e0-54126dc8d5e6
From: Pankaj Dubey <pankaj.dubey@samsung.com>
To: "'Tomasz Figa'" <tomasz.figa@gmail.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: kgene.kim@samsung.com, s.nawrocki@samsung.com, mturquette@linaro.org,
        "'Chander Kashyap'" <k.chander@samsung.com>,
        "'Abhilash Kesavan'" <a.kesavan@samsung.com>
References: <1410328565-25122-1-git-send-email-pankaj.dubey@samsung.com>
 <54122962.5020903@gmail.com>
In-reply-to: <54122962.5020903@gmail.com>
Subject: RE: [PATCH] clk: samsung: exynos5260: fix typo in clock name
Date: Fri, 12 Sep 2014 09:23:50 +0530
Message-id: <000401cfce3d$3fc3b0b0$bf4b1210$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQGjcMNdvmvoOe4ebVgYUdsP7pvQZwFqBtAdnEpIAaA=
Content-language: en-us
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrEIsWRmVeSWpSXmKPExsWyRsSkVvdErlCIwesV6haP1yxmsli1YQmL
	Re+Cq2wWmx5fY7W4vGsOm8WM8/uYLJ5OuMhmcfhNO6vFql1/GB04PXbOusvucefaHjaPzUvq
	Pfq2rGL0+LxJLoA1issmJTUnsyy1SN8ugStj/+ydbAUTOCo2trxmamA8y9bFyMkhIWAicXTe
	QmYIW0ziwr31QHEuDiGBpYwS39bNZYYpOn2qnwkiMZ1RYs6Jv4wQzl9Gic3NG8FGsQnoSjx5
	D9LBxSEiMIVRYuXmVjCHWWAxo8TZpztZQKqEBNIlLu2fDGRzcHAKaErsPqsHEhYWcJU40nID
	bB2LgKrE9q+7wMp5BSwl5p2bxwphC0r8mHwPLM4soCWxfudxJghbXmLzmrdQpypI7Dj7mhHE
	FhGwkni8/jEzRI24xKQHD9lB7pEQ+MkucaP3LNQyAYlvkw+B3SMhICux6QDUHEmJgytusExg
	lJiFZPUsJKtnIVk9C8mKBYwsqxhFUwuSC4qT0osM9YoTc4tL89L1kvNzNzECo/r0v2e9Oxhv
	H7A+xCjAwajEw1vBIhgixJpYVlyZe4jRFOiiicxSosn5wNSRVxJvaGxmZGFqYmpsZG5ppiTO
	qyj1MxgYhoklqdmpqQWpRfFFpTmpxYcYmTg4pRoYDS0P/f3o9VhXcolHyelreSkza8sKeWLe
	79RknZNzXnpDspGLA8/6Dyl9frtN1sx1E3ke4PZv81FJnrC5DLuj9obWTbvRN1Pottupmy/Y
	dTO75224FWf5a/UNL8UFs3+z3Ha1P3/72/ljaquVc1jUxGXuzfcIEjmffaDqM+vqS7kzV7D5
	5G8rU2Ipzkg01GIuKk4EACZ7zsrlAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprDKsWRmVeSWpSXmKPExsVy+t9jQd0TuUIhBnN3yVs8XrOYyWLVhiUs
	Fr0LrrJZbHp8jdXi8q45bBYzzu9jsng64SKbxeE37awWq3b9YXTg9Ng56y67x51re9g8Ni+p
	9+jbsorR4/MmuQDWqAZGm4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE3FRb
	JRefAF23zBygg5QUyhJzSoFCAYnFxUr6dpgmhIa46VrANEbo+oYEwfUYGaCBhDWMGftn72Qr
	mMBRsbHlNVMD41m2LkZODgkBE4nTp/qZIGwxiQv31gPFuTiEBKYzSsw58ZcRwvnLKLG5eSNY
	B5uArsST93OZQRIiAlMYJVZubgVzmAUWM0qcfbqTBaRKSCBd4tL+yUA2BwengKbE7rN6IGFh
	AVeJIy03mEFsFgFVie1fd4GV8wpYSsw7N48VwhaU+DH5HlicWUBLYv3O40wQtrzE5jVvmSFO
	VZDYcfY1I4gtImAl8Xj9Y2aIGnGJSQ8esk9gFJqFZNQsJKNmIRk1C0nLAkaWVYyiqQXJBcVJ
	6blGesWJucWleel6yfm5mxjBKeOZ9A7GVQ0WhxgFOBiVeHgrWQRDhFgTy4orcw8xSnAwK4nw
	NvkLhQjxpiRWVqUW5ccXleakFh9iNAX6dCKzlGhyPjCd5ZXEGxqbmJsam1qaWJiYWSqJ8x5s
	tQ4EBldiSWp2ampBahFMHxMHp1QDo6th4DyePwluRr/M9s1pPTelbllFSui6M4983ke2v+OR
	mqvr+FE45oH6E/nfcgLyHSW3rszZd5bxwh7F7E3Kv37YZ8320Lq9wfDozad1f/QqLl4x2Rsh
	p3j4dFnBAz/DuHViZ9xln0o8Dpq7KoBTml/z9L/PXcLhmdpVx0K87wbUi2v0dLtuVGIpzkg0
	1GIuKk4EAOedRysvAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tomasz,

On Friday, September 12, 2014, Tomasz Figa wrote,
> To: Pankaj Dubey; linux-arm-kernel@lists.infradead.org; linux-samsung-
> soc@vger.kernel.org; linux-kernel@vger.kernel.org
> Cc: kgene.kim@samsung.com; s.nawrocki@samsung.com; mturquette@linaro.org;
> Chander Kashyap; Abhilash Kesavan
> Subject: Re: [PATCH] clk: samsung: exynos5260: fix typo in clock name
> 
> Hi Pankaj,
> 
> On 10.09.2014 07:56, Pankaj Dubey wrote:
> > From: Chander Kashyap <k.chander@samsung.com>
> >
> > The parent name added in parent list as
> > mout_phyclk_mipi_dphy_4l_m_txbyte_clkhs_p, is different than the
> > defined parent due to typo.
> >
> > Signed-off-by: Abhilash Kesavan <a.kesavan@samsung.com>
> > Signed-off-by: Chander Kashyap <k.chander@samsung.com>
> 
> Missed your sign-off? You can reply with it inline and I will add it when
applying this
> weekend.
> 

OK.

> P.S. Please keep me on CC when sending patches for Samsung clock drivers.

Sure.

Thanks,
Pankaj Dubey
> 
> Best regards,
> Tomasz

