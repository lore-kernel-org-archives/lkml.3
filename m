Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753415Ab3GHBef (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jul 2013 21:34:35 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:50396 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753326Ab3GHBec (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jul 2013 21:34:32 -0400
X-AuditID: cbfee690-b7f6f6d00000740c-2d-51da172652e7
Message-id: <51DA1725.3070403@samsung.com>
Date: Mon, 08 Jul 2013 10:34:29 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: myungjoo.ham@samsung.com, gregkh@linuxfoundation.org, kishon@ti.com,
        gg@slimlogic.co.uk, devicetree-discuss@lists.ozlabs.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        grant.likely@linaro.org, rob.herring@calxeda.com
Subject: Re: [PATCH 1/2] extcon: palmas: rename device tree binding matching
 with file name
References: <1373032792-29001-1-git-send-email-ldewangan@nvidia.com>
In-reply-to: <1373032792-29001-1-git-send-email-ldewangan@nvidia.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrPIsWRmVeSWpSXmKPExsWyRsSkQFdN/FagwfV/JhYHZj9ktejf4mJx
	4M8ORovmxevZLC487WGzWLpvNYvFwrYlLBaXd81hs7jduILN4vCKA0wOXB4LPl9h97hzbQ+b
	x/65a9g9zs9YyOjR2/yOzaNvyypGj6lT/jJ6HL+xncnj8ya5AM4oLpuU1JzMstQifbsErox7
	k1gLFrNXHPxxg7mBcSlbFyMnh4SAicTOn2eYIWwxiQv31gPFuTiEBJYySiw40wBXdPTqS0aI
	xCJGiVsXFzBDOC8YJT6efgBWxSugJbHtyxkwm0VAVWLj2QawsWxA8f0vboDFRQXCJFZOv8IC
	US8o8WPyPTBbBKjm24F/YEOZBT4yStx9tJMRJCEsECvx+9tyoGYOoG0uEo93eoGEOQVcJWaf
	amAHsZkFdCT2t05jg7DlJTaveQv1zl92iZPPpSHuEZD4NvkQC8gYCQFZiU0HoEokJQ6uuMEy
	gVFsFpKLZiGZOgvJ1AWMzKsYRVMLkguKk9KLTPSKE3OLS/PS9ZLzczcxAiP39L9nE3Yw3jtg
	fYgxGWjlRGYp0eR8YOTnlcQbGpsZWZiamBobmVuakSasJM6r3mIdKCSQnliSmp2aWpBaFF9U
	mpNafIiRiYNTqoFR2HlO1abJdadY/ojeqt0wO3zr9bzjvJWr/03wlxFS3+pxbWr8/Y16zrFX
	Hpq8qFntdM5Gg3G5RXa1uLSvKnu4xLJIRn+pq6H6HT6XVs9U2vj4QvwPyzUbZH5u4d3GJCvx
	6wxfn8s2yZbsfE3bHfK3Uh6ve8CX5y9fmXNvS1M2/+bL2kUp4RpKLMUZiYZazEXFiQAYnSlJ
	8gIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrLKsWRmVeSWpSXmKPExsVy+t9jAV018VuBBt139CwOzH7IatG/xcXi
	wJ8djBbNi9ezWVx42sNmsXTfahaLhW1LWCwu75rDZnG7cQWbxeEVB5gcuDwWfL7C7nHn2h42
	j/1z17B7nJ+xkNGjt/kdm0ffllWMHlOn/GX0OH5jO5PH501yAZxRDYw2GamJKalFCql5yfkp
	mXnptkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUCXKimUJeaUAoUCEouLlfTtME0I
	DXHTtYBpjND1DQmC6zEyQAMJaxgz7k1iLVjMXnHwxw3mBsalbF2MnBwSAiYSR6++ZISwxSQu
	3FsPFOfiEBJYxChx6+ICZgjnBaPEx9MPwDp4BbQktn05A2azCKhKbDzbwAxiswHF97+4ARYX
	FQiTWDn9CgtEvaDEj8n3wGwRoJpvB/6BDWUW+MgocffRTrDVwgKxEr+/LQdq5gDa5iLxeKcX
	SJhTwFVi9qkGdhCbWUBHYn/rNDYIW15i85q3zBMYBWYhWTELSdksJGULGJlXMYqmFiQXFCel
	5xrqFSfmFpfmpesl5+duYgQnhmdSOxhXNlgcYhTgYFTi4ZU4fTNQiDWxrLgy9xCjBAezkgiv
	OOutQCHelMTKqtSi/Pii0pzU4kOMycAQmMgsJZqcD0xaeSXxhsYmZkaWRuaGFkbG5qQJK4nz
	Hmi1DhQSSE8sSc1OTS1ILYLZwsTBKdXAKF1d/DeqYnPqmqdPn067sm3z7sh/H6u7T5XUCvTp
	lOwQWn09MDfxSdCFUJOsRdslHeMy3jIyxNyS/a918HixINfcrf18W5Jsms7UvJy29dd91q7/
	n4Q0JffXPvkYEuL6M6FfdV1Ba8R8phk7HCqdXi2d8ju2ca2B0M/o/DKmx48uLLeexbyuRIml
	OCPRUIu5qDgRANAfqwBQAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/05/2013 10:59 PM, Laxman Dewangan wrote:
> The driver name is extcon/extcon-palmas.c and hence renaming the
> device tree binding document to extcon-palmas.txt.
> 
> Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
> ---
>  .../extcon/{extcon-twl.txt => extcon-palmas.txt}   |    0
>  1 files changed, 0 insertions(+), 0 deletions(-)
>  rename Documentation/devicetree/bindings/extcon/{extcon-twl.txt => extcon-palmas.txt} (100%)
> 
> diff --git a/Documentation/devicetree/bindings/extcon/extcon-twl.txt b/Documentation/devicetree/bindings/extcon/extcon-palmas.txt
> similarity index 100%
> rename from Documentation/devicetree/bindings/extcon/extcon-twl.txt
> rename to Documentation/devicetree/bindings/extcon/extcon-palmas.txt
> 

Applied patch1 and patch2.

You can check it on following git repo:
- git.kernel.org/cgit/linux/kernel/git/chanwoo/extcon.git (extcon-linus)

Thanks,
Chanwoo Choi
