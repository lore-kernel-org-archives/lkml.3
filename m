Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932540Ab3LIJ0O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 04:26:14 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:18441 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760715Ab3LIJ0K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 04:26:10 -0500
Date: Mon, 09 Dec 2013 18:26:08 +0900
From: Jingoo Han <jg1.han@samsung.com>
Subject: Re: [PATCH] usb: ohci-exynos: Change to use phy provided by the
 generic phy framework
In-reply-to: <20131209015553.GA27542@kroah.com>
To: "'Greg KH'" <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-usb@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm@vger.kernel.org, "'Kamil Debski'" <k.debski@samsung.com>,
        "'Kyungmin Park'" <kyungmin.park@samsung.com>,
        "'Kishon Vijay Abraham I'" <kishon@ti.com>,
        "'Tomasz Figa'" <t.figa@samsung.com>,
        "'Sylwester Nawrocki'" <s.nawrocki@samsung.com>,
        m.szyprowski@samsung.com, gautam.vivek@samsung.com,
        "'Mateusz Krawczuk'" <mat.krawczuk@gmail.com>,
        "'Yulgon Kim'" <yulgon.kim@samsung.com>,
        "'Praveen Paneri'" <p.paneri@samsung.com>,
        "'Anton Tikhomirov'" <av.tikhomirov@samsung.com>,
        "'Kumar Gala'" <galak@codeaurora.org>,
        "'Jingoo Han'" <jg1.han@samsung.com>
Message-id: <000001cef4c0$b123ba90$136b2fb0$%han@samsung.com>
MIME-version: 1.0
X-Mailer: Microsoft Office Outlook 12.0
Content-type: text/plain; charset=us-ascii
Content-language: ko
Content-transfer-encoding: 7bit
Thread-index: Ac70uH5Glb4DcCrtTDGv6JRXYdpGSgAB1Ilg
DLP-Filter: Pass
X-AuditID: cbfee690-b7f676d00000310d-5b-52a58cb08414
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrAKsWRmVeSWpSXmKPExsVy+t8zI90NPUuDDO6sVrNYsvsGq8X8I+dY
	LfrfLGS1aLtykN3i3IIZjBaXF15itfjx+gKbxYWnPWwWZ5vesFtM2/mf1eLyrjlsFjPO72Oy
	WLSsldli7ZG77BZn+2+zWZzf0slkcfhNO6vF+hmvWSw6zh5kdxD2uNzXy+Sxc9Zddo+3DwM8
	+rasYvQ4fmM7k8fnTXIBbFFcNimpOZllqUX6dglcGbsWfGMsWMtZ0fWep4FxF3sXIyeHhICJ
	xPNDU5ghbDGJC/fWs3UxcnEICSxjlLjw7w8zTNGuKccZIRLTGSU2XVgGVfWLUWLp//dsIFVs
	AmoSX74cBhsrIiAn8evPCbAiZoElrBKT7jaDJYQEkiR2rp7IAmJzCuhL3Lw6CSwuLJAg0TRz
	LZjNIqAq8bhzJWsXIwcHr4CtxI0/eSBhXgFBiR+T74G1MgtoSazfeZwJwpaX2LzmLTNIuYSA
	usSjv7oQJxhJXNvyixGiRERi34t3jBDPnOGQ2H46HWKTgMS3yYdYIFplJTYdgPpXUuLgihss
	ExglZiFZPAvJ4llIFs9CsmEBI8sqRtHUguSC4qT0IhO94sTc4tK8dL3k/NxNjJDUMWEH470D
	1ocYk4HWT2SWEk3OB6aevJJ4Q2MzIwtTE1NjI3NLM9KElcR51R4lBQkJpCeWpGanphakFsUX
	leakFh9iZOLglGpgzJFcUFB/d2nQDb5TKq2e4WGl60Q/rNpRZijsrXPh3fcPIn9/TD0esUOS
	RerKFvbpORFPJd782pGcvdmxcd3ayROnKhdKcn9h3LzM6IAUn8jTnrV7M+6emuZVkPU3/JDs
	6W9hE1tnxUvErJdfw38phTXm5fufM+vuRf6w6P92uNFjyccGJ/N/nEosxRmJhlrMRcWJAJ6b
	DFMzAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrHKsWRmVeSWpSXmKPExsVy+t9jQd0NPUuDDF5tVbBYsvsGq8X8I+dY
	LfrfLGS1aLtykN3i3IIZjBaXF15itfjx+gKbxYWnPWwWZ5vesFtM2/mf1eLyrjlsFjPO72Oy
	WLSsldli7ZG77BZn+2+zWZzf0slkcfhNO6vF+hmvWSw6zh5kdxD2uNzXy+Sxc9Zddo+3DwM8
	+rasYvQ4fmM7k8fnTXIBbFENjDYZqYkpqUUKqXnJ+SmZeem2St7B8c7xpmYGhrqGlhbmSgp5
	ibmptkouPgG6bpk5QH8oKZQl5pQChQISi4uV9O0wTQgNcdO1gGmM0PUNCYLrMTJAAwnrGDN2
	LfjGWLCWs6LrPU8D4y72LkZODgkBE4ldU44zQthiEhfurWfrYuTiEBKYziix6cIyKOcXo8TS
	/+/ZQKrYBNQkvnw5DNYtIiAn8evPCbAiZoElrBKT7jaDJYQEkiR2rp7IAmJzCuhL3Lw6CSwu
	LJAg0TRzLZjNIqAq8bhzJWsXIwcHr4CtxI0/eSBhXgFBiR+T74G1MgtoSazfeZwJwpaX2Lzm
	LTNIuYSAusSjv7oQJxhJXNvyixGiRERi34t3jBMYhWYhmTQLyaRZSCbNQtKygJFlFaNoakFy
	QXFSeq6hXnFibnFpXrpecn7uJkZwanomtYNxZYPFIUYBDkYlHt4VrEuDhFgTy4orcw8xSnAw
	K4nwzmoDCvGmJFZWpRblxxeV5qQWH2JMBvpzIrOUaHI+MG3mlcQbGpuYGVkamVkYmZibkyas
	JM57oNU6UEggPbEkNTs1tSC1CGYLEwenVAPjxtlp1+L0BCzDt1Xuu1p86JXtTEuTZSuczD6c
	OGX52MHtvfDjlAXnlqT9c51xL0r24sQKps6dWX2/3ykbFJb89me+6/iVWeFMjOOi2lNct+5P
	/rH6ytSLamFRvfEXz+9nmrtSZkvz0/p1lzNX/uR4d+QDTy1z+dd7Ot9tuLN43r5YKfXs8e5z
	DUosxRmJhlrMRcWJAP90Gr2RAwAA
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
References: <001401ceda8f$67f1ee50$37d5caf0$%han@samsung.com>
 <20131209015553.GA27542@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, December 09, 2013 10:56 AM, Greg KH wrote:
> On Wed, Nov 06, 2013 at 10:27:49AM +0900, Jingoo Han wrote:
> > Change the phy provider used from the old usb phy specific to a new one
> > using the generic phy framework.
> >
> > Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> > Cc: Kamil Debski <k.debski@samsung.com>
> > ---
> > Exynos OHCI driver also uses Exynos USB2.0 PHY. Thus, I make this
> > patch based-on Kamil Debski's patchset for adding Exynos USB 2.0 PHY
> > driver.
> > (http://www.spinics.net/lists/linux-samsung-soc/msg24104.html)
> >
> >  drivers/usb/host/ohci-exynos.c |   28 ++++++++--------------------
> >  1 file changed, 8 insertions(+), 20 deletions(-)
> 
> This has some fuzz when applied to my tree, care to redo it against my
> usb-next branch of the usb.git tree on git.kernel.org?

Hi Greg,

This patch should be updated, based on Kamil Debski's  V4 patchset
for adding Exynos USB 2.0 PHY driver [1].
I will send v2 patch based on Kamil Debski's  V4 patchset [1].

[1] [PATCH v4 0/9] phy: Add new Exynos USB 2.0 PHY driver 
     (http://www.spinics.net/lists/linux-usb/msg98911.html)

Thank you.

Best regards,
Jingoo Han

