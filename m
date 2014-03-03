Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755566AbaCCXtd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 18:49:33 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:16686 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755182AbaCCXta (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 18:49:30 -0500
X-AuditID: cbfee690-b7f266d00000287c-ea-53151507c87f
From: Jingoo Han <jg1.han@samsung.com>
To: "'Kumar Gala'" <galak@codeaurora.org>,
        "'Kishon Vijay Abraham I'" <kishon@ti.com>
Cc: "'Yuvaraj Kumar C D'" <yuvaraj.cd@gmail.com>, kgene.kim@samsung.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        mark.rutland@arm.com, "'Yuvaraj Kumar C D'" <yuvaraj.cd@samsung.com>,
        sander@humilis.net, swarren@wwwdotorg.org, b.zolnierkie@samsung.com,
        ks.giri@samsung.com, t.figa@samsung.com, joshi@samsung.com,
        grant.likely@linaro.org, christoffer.dall@linaro.com,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <1393824160-27040-1-git-send-email-yuvaraj.cd@samsung.com>
 <1393824160-27040-3-git-send-email-yuvaraj.cd@samsung.com>
 <53146E84.7060508@ti.com> <C12D2EA6-2766-4C9A-8746-9B8E1A5844CD@codeaurora.org>
In-reply-to: <C12D2EA6-2766-4C9A-8746-9B8E1A5844CD@codeaurora.org>
Subject: Re: [PATCH V9 2/2] ARM: dts: Enable ahci sata and sata phy
Date: Tue, 04 Mar 2014 08:49:26 +0900
Message-id: <000301cf373b$36314330$a293c990$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac82+faodEvmZnJHSB2MnH1YpAzV7gAQLZDw
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrFKsWRmVeSWpSXmKPExsVy+t8zY112UdFggxvXpCw2zljParH4wzo2
	i/lHzrFa9L9ZyGpx4M8ORovLCy+xWnzf9YXdonfBVTaLC097gEqO7mCy2PT4GqvFwrYlLBaX
	d81hs1h6/SKTxYp7u9ktXh1sY7FYP+M1i8XDo92sFmdPlTsIe6yZt4bR43JfL5PHzll32T0+
	vV3M7PFp5mR2jzvX9rB5bF5S79G3ZRWjx/Eb25k8Pm+S89g4NzSAO4rLJiU1J7MstUjfLoEr
	4/XuXSwFEzgrPh+9y9bA2MTexcjJISFgIrG6fTorhC0mceHeejYQW0hgGaPEvE9mMDX3Dt8C
	qucCik9nlHjxdxczhPObUeLHmllg3WwCahJfvhwGmyoiECzx79ZUFpAiZoHXzBIz3z9ggui4
	yijx7+ghJpAqTgEniVkL57CA2MICzhIPXtwHs1kEVCXuLf4NdgevgK3E9ftNrBC2oMSPyffA
	apgFtCTW7zzOBGHLS2xe8xboJA6gW9UlHv3VhTjCSGLrojZWiBIRiX0v3jGC3CAh8IFD4tqE
	DmaIXQIS3yYfYoHolZXYdIAZ4mVJiYMrbrBMYJSYhWTzLCSbZyHZPAvJigWMLKsYRVMLkguK
	k9KLTPSKE3OLS/PS9ZLzczcxQtLNhB2M9w5YH2JMBlo/kVlKNDkfmK7ySuINjc2MLExNTI2N
	zC3NSBNWEudVe5QUJCSQnliSmp2aWpBaFF9UmpNafIiRiYNTqoGRvULrJsuSMFP39QHSbJOS
	+i1Mde9aXxGMPXR+q9Csj/UpUZEr7GpO8N+4NPWf8FsuwxfB98z2NZx9cPm6V5/yr9hvC+Km
	dL3YYs24eLNf7iIp1bJv/cp7n2eaxujc6ufJKAkP+3f+o0K+d/rbknV2k3VNKh6sTDBofZ2+
	YtfUIzzcZ781O3IosRRnJBpqMRcVJwIAmBmFOE0DAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprBJsWRmVeSWpSXmKPExsVy+t9jQV12UdFgg02nRCw2zljParH4wzo2
	i/lHzrFa9L9ZyGpx4M8ORovLCy+xWnzf9YXdonfBVTaLC097gEqO7mCy2PT4GqvFwrYlLBaX
	d81hs1h6/SKTxYp7u9ktXh1sY7FYP+M1i8XDo92sFmdPlTsIe6yZt4bR43JfL5PHzll32T0+
	vV3M7PFp5mR2jzvX9rB5bF5S79G3ZRWjx/Eb25k8Pm+S89g4NzSAO6qB0SYjNTEltUghNS85
	PyUzL91WyTs43jne1MzAUNfQ0sJcSSEvMTfVVsnFJ0DXLTMH6D0lhbLEnFKgUEBicbGSvh2m
	CaEhbroWMI0Rur4hQXA9RgZoIGEdY8br3btYCiZwVnw+epetgbGJvYuRk0NCwETi3uFbULaY
	xIV769m6GLk4hASmM0q8+LuLGcL5zSjxY80sVpAqNgE1iS9fDoN1iAgES/y7NZUFpIhZ4DWz
	xMz3D5ggOq4ySvw7eogJpIpTwEli1sI5LCC2sICzxIMX98FsFgFViXuLf7OB2LwCthLX7zex
	QtiCEj8m3wOrYRbQkli/8zgThC0vsXnNW6CTOIBuVZd49FcX4ggjia2L2lghSkQk9r14xziB
	UWgWkkmzkEyahWTSLCQtCxhZVjGKphYkFxQnpeca6hUn5haX5qXrJefnbmIEp7NnUjsYVzZY
	HGIU4GBU4uGdMU0kWIg1say4MvcQowQHs5IIryWvaLAQb0piZVVqUX58UWlOavEhxmSgRycy
	S4km5wNTbV5JvKGxiZmRpZGZhZGJuTlpwkrivAdarQOFBNITS1KzU1MLUotgtjBxcEo1MJ7c
	85uz3P+e3teji6dXeDM8CT/hw5Gvc3TVVd1dXdsd/OIzd14TfpF+9P2SkDVP0i9efha/qY6j
	t3petfq1STXHAmd8mB97fq3eOpMrERU/L7NO2zn/0vUll/4Zbps2S1u4dKHU01L1G93OnFGp
	2+54/ODb+TXpxmc1bw820fTrn4MLP0155RmoxFKckWioxVxUnAgA3BHO4KsDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, March 04, 2014 1:02 AM, Kumar Gala wrote:
> On Mar 3, 2014, at 5:59 AM, Kishon Vijay Abraham I <kishon@ti.com> wrote:
> 
> >
> >
> > On Monday 03 March 2014 10:52 AM, Yuvaraj Kumar C D wrote:
> >> This patch adds dt entry for ahci sata controller and its
> >> corresponding phy controller.phy node has been added w.r.t
> >> new generic phy framework.
> >>
> >> Signed-off-by: Yuvaraj Kumar C D <yuvaraj.cd@samsung.com>
> >
> > This should go via exynos dt tree.
> >
> > FWIW
> > Acked-by: Kishon Vijay Abraham I <kishon@ti.com>
> >> -
> 
> Its a nit, but the subject really should have 'exynos' or some related qualifier. 
> We aren't enabling ahci sata & phy for all of ARM

I agree with your opinion.
The subject should be fixed in order to get rid of confusion.

For example, one of the followings looks good.

  ARM: dts: exynos5250: Enable ahci sata and sata phy
  ARM: dts: Enable ahci sata and sata phy for exynos5250

Best regards,
Jingoo Han

> 
> - k
> 
> --
> Employee of Qualcomm Innovation Center, Inc.
> Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation

