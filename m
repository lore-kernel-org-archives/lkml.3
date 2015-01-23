Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753561AbbAWG4r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 01:56:47 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:47685 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751059AbbAWG4p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 01:56:45 -0500
X-AuditID: cbfee691-f79b86d000004a5a-71-54c1f0a37eb6
From: Kukjin Kim <kgene@kernel.org>
To: "'Jaewon Kim'" <jaewon02.kim@samsung.com>,
        "'Kukjin Kim'" <kgene@kernel.org>
Cc: "'Chanwoo Choi'" <cw00.choi@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org
References: <1421826960-26491-1-git-send-email-jaewon02.kim@samsung.com>
In-reply-to: <1421826960-26491-1-git-send-email-jaewon02.kim@samsung.com>
Subject: RE: [PATCH RESEND 0/2] Add regulator-haptic device tree
Date: Fri, 23 Jan 2015 15:56:35 +0900
Message-id: <0c4e01d036d9$ba40dac0$2ec29040$@kernel.org>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Content-language: ko
Thread-index: AQMX83OVldaw6UCplgsgnB/04+Xx95o9zEpg
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrEIsWRmVeSWpSXmKPExsWyRsSkRXfxh4MhBl9malhc//Kc1WJHwxFW
	i/7Hr5ktbn76xmpxedccNosZ5/cxObB5bFrVyebRt2UVo8fnTXIBzFFcNimpOZllqUX6dglc
	GX+6fQqusVRcOn2NtYHxLnMXIyeHhICJxJPmbjYIW0ziwr31QDYXh5DAUkaJRfc6mGCK/p8/
	wQJiCwksYpToag6AKPrLKDHh1AWgSRwcbALKEo1N+iA1wgJaEgu3NIHViwj4SDzYsYEFpJ5Z
	oItRYt2X+VCDPCQOvH/ACtLLKeApcXWmHESvg8STxRC7WARUJT5dPQRm8wpYSGzrfsAOYQtK
	/Jh8DyzODLRr/c7jTBC2vMTmNW+hHlOQ2HH2NSNEXERi34t3jBD3GEls6uphBLlHQuAau0T3
	lGdMEMsEJL5NBlnGAZSQldh0AGqOpMTBFTdYJjBKzkKyehaS1bOQrJ6FZN0CRpZVjKKpBckF
	xUnpRaZ6xYm5xaV56XrJ+bmbGIFRe/rfs4k7GO8fsD7EKMDBqMTD27DlYIgQa2JZcWXuIUZT
	oIsmMkuJJucDU0NeSbyhsZmRhamJqbGRuaWZkjivjvTPYCGB9MSS1OzU1ILUovii0pzU4kOM
	TBycUg2M2+Pdfrv8XWB77JjetXuN0983vc65Oiv53fJX5vdnrDn37d7VHDadR6d5D/E//vRW
	gyepZUH58XmrH2ce0hTm1fb39/y3SON40YnZjxdwnnEvNZhm4vi4v87vkVqF36w7F27EGKjc
	/nr81SXOPTldnJ/kZsSb3Vi+4aKHC6+anRzjq5L9h5MXnlNiKc5INNRiLipOBADZEddk1QIA	AA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuphleLIzCtJLcpLzFFi42I5/e+xgO7iDwdDDLZtVrG4/uU5q8WOhiOs
	Fv2PXzNb3Pz0jdXi8q45bBYzzu9jcmDz2LSqk82jb8sqRo/Pm+QCmKMaGG0yUhNTUosUUvOS
	81My89JtlbyD453jTc0MDHUNLS3MlRTyEnNTbZVcfAJ03TJzgBYrKZQl5pQChQISi4uV9O0w
	TQgNcdO1gGmM0PUNCYLrMTJAAwnrGDP+dPsUXGOpuHT6GmsD413mLkZODgkBE4n/50+wQNhi
	EhfurWcDsYUEFjFKdDUHdDFyAdl/GSUmnLoA1MDBwSagLNHYpA9SIyygJbFwSxNYr4iAj8SD
	HRtYQOqZBboYJdZ9mc8CMchD4sD7B6wgvZwCnhJXZ8pB9DpIPFkMsZdFQFXi09VDYDavgIXE
	tu4H7BC2oMSPyffA4sxAu9bvPM4EYctLbF7zFup+BYkdZ18zQsRFJPa9eMcIcY+RxKauHsYJ
	jMKzkIyahWTULCSjZiFpX8DIsopRNLUguaA4KT3XUK84Mbe4NC9dLzk/dxMjOCU8k9rBuLLB
	4hCjAAejEg9vw5aDIUKsiWXFlbmHGCU4mJVEeLsfAYV4UxIrq1KL8uOLSnNSiw8xmgJ9OpFZ
	SjQ5H5iu8kriDY1NzIwsjcwsjEzMzZXEeZXs20KEBNITS1KzU1MLUotg+pg4OKUaGNMOsHFf
	fbSz1D9825Oq1vyby2xn1D7aHjj7ge0ro7Wmf63PGBbIHFz4f1ZJ6hXnfyZH2fd8Likvc7a8
	Yabrq/PrRcOjMDHnDxKahz/MXGAq6RdiI/KaTWjzvKAazWPJ3289jKmfzlN9au7sdfka1n98
	rxT2ZgmGcyctdz9sO0Ev5lbH7l1HpimxFGckGmoxFxUnAgD0AOcMHwMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jaewon Kim wrote:
> 
> This patch series adds regulator-haptic device tree in rinato and monk boards.
> 
> The regulator-haptic has haptic motor and it is controlled by
> voltage of regulator via force feedback framework.
> 
> regualtor-haptic driver merged at linux-next
> ref : https://lkml.org/lkml/2014/12/17/477
> 
Found the series in linux-next.

> Jaewon Kim (2):
>   ARM: dts: exynos3250-rinato: Add regulator-haptic node for haptics
>   ARM: dts: exynos3250-monk: Add regulator-haptic node for haptics
> 
OK, looks good to me, will apply this series.

Thanks,
Kukjin

