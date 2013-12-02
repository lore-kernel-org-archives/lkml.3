Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754536Ab3LBXfr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 18:35:47 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:32405 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754504Ab3LBXfk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 18:35:40 -0500
X-AuditID: cbfee68f-b7f336d00000481b-ce-529d194b738e
From: Jingoo Han <jg1.han@samsung.com>
To: "'Borislav Petkov'" <bp@alien8.de>
Cc: "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org,
        "'Doug Thompson'" <dougthompson@xmission.com>,
        linux-edac@vger.kernel.org, "'Jingoo Han'" <jg1.han@samsung.com>,
        "'Joe Perches'" <joe@perches.com>,
        "'Bjorn Helgaas'" <bhelgaas@google.com>
References: <001501ceefb1$69c96820$3d5c3860$%han@samsung.com>
 <001c01ceefb3$5724d860$056e8920$%han@samsung.com>
 <20131202232043.GF7380@pd.tnic>
In-reply-to: <20131202232043.GF7380@pd.tnic>
Subject: Re: [PATCH 07/39] edac: remove DEFINE_PCI_DEVICE_TABLE macro
Date: Tue, 03 Dec 2013 08:35:39 +0900
Message-id: <003d01ceefb7$356b6f50$a0424df0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac7vtSNCsYwgBA2OSwqTCI/a6oZX+gAAcEbg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrHIsWRmVeSWpSXmKPExsVy+t8zA11vyblBBkdW6lssacqw+LzhH5vF
	1WVnmSyaF69ns7i88BKrxez7j1ksLpxqYLK4vGsOmwOHx/fWPhaPBZtKPfbPXcPu8WXVNWaP
	vi2rGD0+b5LzmHKonSWAPYrLJiU1J7MstUjfLoEr49GVi6wF/9kqTj35wNjAeJK1i5GTQ0LA
	ROLI9dmMELaYxIV769lAbCGBZYwSc6ZWw9T8XDOPqYuRCyi+iFHi3KqZLBDOL0aJa7smMoNU
	sQmoSXz5cpgdxBYRUJHYOfcRG0gRs0Afk8S8zx9ZITomA3X8OQq2m1NAR2LplpVgtrCAq8TN
	qbfB7mARUJXo2fYBbBKvgK3Ex6MtTBC2oMSPyfeAVnMATVWXmDIlFyTMLCAvsXnNW2aQsARQ
	+NFfXYgbjCRWdp9ihigRkdj34h0jyAkSAo0cEn1397FDrBKQ+Db5EAtEr6zEpgPMEB9LShxc
	cYNlAqPELCSLZyEsnoVk8SwkGxYwsqxiFE0tSC4oTkovMtYrTswtLs1L10vOz93ECInr/h2M
	dw9YH2JMBto+kVlKNDkfmBbySuINjc2MLExNTI2NzC3NSBNWEue9/zApSEggPbEkNTs1tSC1
	KL6oNCe1+BAjEwenVANjys876X+P2+VEfWVg2asdIWF64mhkBdtqqeo51y8ZKIQq9xTGCK6J
	zzs5ZW3ZxmWFNls4onQ7tgZmfOw59bWNQ6j+RPhhXr+URrtbRvNZQxxP/PP8eG+HTMWagvtX
	8iIb3Sb2p8wMnWNz2GC+3p3kjSdzXwcvXKWrzDm5cOeVf7P2BC71lsxXYinOSDTUYi4qTgQA
	Zdm28gEDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrDKsWRmVeSWpSXmKPExsVy+t9jAV1vyblBBp8XaVssacqw+LzhH5vF
	1WVnmSyaF69ns7i88BKrxez7j1ksLpxqYLK4vGsOmwOHx/fWPhaPBZtKPfbPXcPu8WXVNWaP
	vi2rGD0+b5LzmHKonSWAPaqB0SYjNTEltUghNS85PyUzL91WyTs43jne1MzAUNfQ0sJcSSEv
	MTfVVsnFJ0DXLTMH6CglhbLEnFKgUEBicbGSvh2mCaEhbroWMI0Rur4hQXA9RgZoIGEdY8aj
	KxdZC/6zVZx68oGxgfEkaxcjJ4eEgInEzzXzmCBsMYkL99azdTFycQgJLGKUOLdqJguE84tR
	4tquicwgVWwCahJfvhxmB7FFBFQkds59BNbBLNDHJDHv80dWiI7JQB1/joLt4BTQkVi6ZSWY
	LSzgKnFz6m1GEJtFQFWiZ9sHsEm8ArYSH4+2MEHYghI/Jt8DWs0BNFVdYsqUXJAws4C8xOY1
	b5lBwhJA4Ud/dSFuMJJY2X2KGaJERGLfi3eMExiFZiEZNAth0Cwkg2Yh6VjAyLKKUTS1ILmg
	OCk911CvODG3uDQvXS85P3cTIzhtPJPawbiyweIQowAHoxIP74Ptc4KEWBPLiitzDzFKcDAr
	ifB28swNEuJNSaysSi3Kjy8qzUktPsSYDPTmRGYp0eR8YErLK4k3NDYxM7I0MrMwMjE3J01Y
	SZz3QKt1oJBAemJJanZqakFqEcwWJg5OqQZG++0TtP+dmNXDtVR1eb6XgvUe32dblkacnpgU
	f+l574zooH+vTVJ///DhNvK6a7epeu6vtqvXerkvvSypvyo504SX31tesqf11dvL/WtavOYe
	7HfxVNdklahaHfr4rsCu9Jkzk+0b8rjyTiTnxM+MKrtzvupx3Y8Ub1/phJXnda15k18kLbFR
	YinOSDTUYi4qTgQAa41kUV8DAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, December 03, 2013 8:21 AM, Borislav Petkov wrote:
> On Tue, Dec 03, 2013 at 08:07:57AM +0900, Jingoo Han wrote:
> > Don't use DEFINE_PCI_DEVICE_TABLE macro, because this macro
> > is not preferred.
> 
> Says who and why?
> 
> The author of the commit message (that is you) should explain to the
> onlooker (that is me) why this patch needs to be applied.

(+cc Joe Perches, Bjorn Helgaas)

Hi Borislav Petkov,

According to the Greg Kroah-Hartman, 
"Yeah, and it's a horrid macro that deserves to be removed,
please don't use it in more places."

Currently, there is no other bus that has something like this
macro for their device ids. Thus, DEFINE_PCI_DEVICE_TABLE macro
should be removed.

I hope that these patches will be merged through Greg Kroah-Hartman's
'driver-core.git', with 'Acked-by' of each subsystem maintainer.

Best regards,
Jingoo Han

