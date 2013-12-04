Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755591Ab3LDATX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 19:19:23 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:46983 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751206Ab3LDATU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 19:19:20 -0500
X-AuditID: cbfee68e-b7fee6d000003b32-d9-529e750693ac
From: Jingoo Han <jg1.han@samsung.com>
To: "'Shevchenko, Andriy'" <andriy.shevchenko@intel.com>
Cc: "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, "'Koul, Vinod'" <vinod.koul@intel.com>,
        "'Williams, Dan J'" <dan.j.williams@intel.com>,
        dmaengine@vger.kernel.org, "'Joe Perches'" <joe@perches.com>,
        "'Jonas Bonn'" <jonas@southpole.se>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <001501ceefb1$69c96820$3d5c3860$%han@samsung.com>
 <001b01ceefb2$ffd995f0$ff8cc1d0$%han@samsung.com>
 <1386072642.1871.46.camel@smile>
In-reply-to: <1386072642.1871.46.camel@smile>
Subject: Re: [PATCH 06/39] dma: remove DEFINE_PCI_DEVICE_TABLE macro
Date: Wed, 04 Dec 2013 09:19:18 +0900
Message-id: <001501cef086$78d015f0$6a7041d0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: AQHO8CC/NAqACFd7PEqF7MSlwvbprJpDKxVw
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrHIsWRmVeSWpSXmKPExsVy+t8zY1220nlBBldOaVrMXLac3WL61AuM
	Fqun/mW1aF68ns3i8sJLrBaz7z9msfgz8wOTxeVdc9gsXvbtZ3Hg9Fi85yWTx/65a9g9vqy6
	xuzRt2UVo8epntXMHp83yQWwRXHZpKTmZJalFunbJXBlTF2yk6ngIU/F24mv2RsYt3J1MXJy
	SAiYSOw48pcZwhaTuHBvPVsXIxeHkMAyRomu2X/Yuxg5wIpO3AiDiC9ilPi+eSszhPMLyGk7
	ygbSzSagJvHly2F2EFtEwELi9btV7CBFzALbmCSef30ENXYKo8S06SvYQMZyCuhKzLvEAWIK
	C7hIHP+SBtLLIqAqsadrIiuIzStgK7Hl0FwmCFtQ4sfkeywg5cwC6hJTpuSChJkF5CU2r3nL
	DHGnusSjv7oQFxhJvOq8xQ5RIiKx78U7RpADJARaOSRer2xmgVglIPFt8iEWiF5ZiU0HoOEg
	KXFwxQ2WCYwSs5AsnoWweBaSxbOQbFjAyLKKUTS1ILmgOCm9yEivODG3uDQvXS85P3cTIySu
	+3Yw3jxgfYgxGWj7RGYp0eR8YFrIK4k3NDYzsjA1MTU2Mrc0I01YSZx30cOkICGB9MSS1OzU
	1ILUovii0pzU4kOMTBycUg2MBilJ0dLn31l7yLTx1UcpbayultvUNOdWruq8/JVGjFVi8zPM
	ShI9s6dfFv2zXmfOvaj7JtEx5QeW2TVJWRu+5Nz/8MUNFn9OB3m1t6vn6n+bcCq71fvM1IDt
	s3dOV9r/o2CS+wGLF2VqP52a5eccD457N1N0NaPNkyMZ/L+uPd1uyVwzPfezEktxRqKhFnNR
	cSIAlDujZwEDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNKsWRmVeSWpSXmKPExsVy+t9jAV220nlBBj33VCxmLlvObjF96gVG
	i9VT/7JaNC9ez2ZxeeElVovZ9x+zWPyZ+YHJ4vKuOWwWL/v2szhweize85LJY//cNeweX1Zd
	Y/bo27KK0eNUz2pmj8+b5ALYohoYbTJSE1NSixRS85LzUzLz0m2VvIPjneNNzQwMdQ0tLcyV
	FPISc1NtlVx8AnTdMnOAzlJSKEvMKQUKBSQWFyvp22GaEBripmsB0xih6xsSBNdjZIAGEtYx
	ZkxdspOp4CFPxduJr9kbGLdydTFycEgImEicuBHWxcgJZIpJXLi3nq2LkYtDSGARo8T3zVuZ
	IZxfQE7bUTaQKjYBNYkvXw6zg9giAhYSr9+tYgcpYhbYxiTx/OsjqPYpjBLTpq9gA1nBKaAr
	Me8SB4gpLOAicfxLGkgvi4CqxJ6uiawgNq+ArcSWQ3OZIGxBiR+T77GAlDMLqEtMmZILEmYW
	kJfYvOYtM8TN6hKP/upCXGAk8arzFjtEiYjEvhfvGCcwCs1CMmgWwqBZSAbNQtKxgJFlFaNo
	akFyQXFSeq6hXnFibnFpXrpecn7uJkZw0ngmtYNxZYPFIUYBDkYlHt4EznlBQqyJZcWVuYcY
	JTiYlUR4WdOAQrwpiZVVqUX58UWlOanFhxiTgd6cyCwlmpwPTGh5JfGGxiZmRpZGZhZGJubm
	pAkrifMeaLUOFBJITyxJzU5NLUgtgtnCxMEp1cA469KGX35zfJSDPggY3Dq/c8IKx6b3hdcZ
	pqiI3q4TW/xyc6neP3eVJaYq7Ex7Dl97zppq7mP+5LSe9mnT2aoXHu/d96BXMcN9nc2x60c2
	JWnt6DrNN8/006ypR6uaJA3tJcund+Wuat55XaO7Im4t0//mdq0pomc092/2DX11R6T9kazU
	BDErJZbijERDLeai4kQAxGQx3V4DAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, December 03, 2013 9:11 PM, Shevchenko, Andriy wrote:
> On Tue, 2013-12-03 at 08:05 +0900, Jingoo Han wrote:
> > Don't use DEFINE_PCI_DEVICE_TABLE macro, because this macro
> > is not preferred.
> 
> I'm sorry, but Documentation/PCI/pci.txt still says "is the preferred
> method".
> 
> Is there any link to patch for Documentation and discussion why change
> is established?

(+cc Joe Perches, Jonas Bonn)

Since last week, there has been discussion about this.
There is no special reason to use DEFINE_PCI_DEVICE_TABLE macro.

According to the Greg Kroah-Hartman,
"Yeah, and it's a horrid macro that deserves to be removed,
please don't use it in more places."

Currently, there is no other bus that has something like this
macro for their device ids. Thus, DEFINE_PCI_DEVICE_TABLE macro
should be removed.

Jonas Bonn (author of DEFINE_PCI_DEVICE_TABLE macro) also agreed
to remove this macro. According to Jonas Bonn,
"Actually, I think I submitted an even uglier macro called 
DECLARE_PCI_DEVICE_TABLE... might have been the first kernel
Patch I  ever sent?  In any case, it should certainly have been
kindly rejected."

After Joe Perches's patch[1] is merged, I will send these patches
to each subsystem maintainer.

[1][PATCH] pci/checkpatch: Deprecate DEFINE_PCI_DEVICE_TABLE
    (http://lkml.org/lkml/2013/12/2/400)

In this patch, Joe Perches fixed 'Documentation/PCI/pci.txt', and
'scripts/checkpatch.pl', in order to guide to use 'struct pci_device_id'
instead of 'DEFINE_PCI_DEVICE_TABLE' macro.

Thank you.

Best regards,
Jingoo Han

Best regards,
Jingoo Han

