Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751354Ab3JRFbh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 01:31:37 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:64536 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751185Ab3JRFbf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 01:31:35 -0400
X-AuditID: cbfee68e-b7f486d0000040b6-91-5260c7a3f53a
From: Jingoo Han <jg1.han@samsung.com>
To: "'Zhenzhong Duan '" <zhenzhong.duan@oracle.com>,
        "'Bjorn Helgaas'" <bhelgaas@google.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        "'xen-devel'" <xen-devel@lists.xen.org>,
        "'Konrad Rzeszutek Wilk'" <konrad.wilk@oracle.com>,
        "'Feng Jin'" <joe.jin@oracle.com>,
        "'Sucheta Chakraborty'" <sucheta.chakraborty@qlogic.com>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <525E32FC.3010604@oracle.com>
In-reply-to: <525E32FC.3010604@oracle.com>
Subject: Re: [PATCH 1/3] PCI: Refactor restore_msi_irqs - code movement
Date: Fri, 18 Oct 2013 14:31:15 +0900
Message-id: <000001cecbc3$43853e30$ca8fba90$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac7KOX0IA3UN7ZouSSiYlK18ngnskgBiUaYQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrHIsWRmVeSWpSXmKPExsVy+t8zQ93FxxOCDBquS1ksacqwuLzwEqvF
	o77njBbLFj9ltLi8aw6bxdl5x9ksLn06x2ix5ONiFovNPx+zOHB6LNhU6nF0928mj49Pb7F4
	rPtygt2jb8sqRo/Pm+QC2KK4bFJSczLLUov07RK4Mo7efcRe8JilYv+ZS4wNjH+Zuxg5OSQE
	TCQez77EBmGLSVy4tx7I5uIQEljGKPF0+0N2mKKJM3eyQySmM0r0/roE5fxilHhyo4UVpIpN
	QE3iy5fDQAkODhGBKIlJx1hBapgFZjNJTN18HmydkICmxJ/JrWA2p4CWxPwpjWCrhQXcJY61
	fmUCsVkEVCU+PbkMFucVsJU4eGMzlC0o8WPyPRYQmxmod/3O40wQtrzE5jVvmUH2SgioSzz6
	qwsSFhEwktjz5ytUiYjEvhfvGCGeaeSQeHZSFWKVgMS3yYdYIFplJTYdgAaKpMTBFTdYJjBK
	zEKyeBaSxbOQLJ6FZMMCRpZVjKKpBckFxUnpRUZ6xYm5xaV56XrJ+bmbGCFx3beD8eYB60OM
	yUDrJzJLiSbnA9NCXkm8obGZkYWpiamxkbmlGWnCSuK8ai3WgUIC6YklqdmpqQWpRfFFpTmp
	xYcYmTg4pRoYW5m92Q9/ZJm3dMcBf/l/B14JCWlOqt7kxd+/4HfIpenPlddeXWWR+VLYbrJJ
	5hetM1z3It7sZrz/dokdm8BWft6vE85d/s3JU1D60bCS867lHd5Cg/52vZVs7uYfCgLvXmYV
	av9vf032h5ZGc0WjY8HzxOiNTo2+rw7nTE1I9f+0e+Npw+sNSizFGYmGWsxFxYkAUcocoQED	AAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrDKsWRmVeSWpSXmKPExsVy+t9jQd3FxxOCDHZMErNY0pRhcXnhJVaL
	R33PGS2WLX7KaHF51xw2i7PzjrNZXPp0jtFiycfFLBabfz5mceD0WLCp1OPo7t9MHh+f3mLx
	WPflBLtH35ZVjB6fN8kFsEU1MNpkpCampBYppOYl56dk5qXbKnkHxzvHm5oZGOoaWlqYKynk
	Jeam2iq5+AToumXmAB2lpFCWmFMKFApILC5W0rfDNCE0xE3XAqYxQtc3JAiux8gADSSsY8w4
	evcRe8Fjlor9Zy4xNjD+Ze5i5OSQEDCRmDhzJzuELSZx4d56ti5GLg4hgemMEr2/LrFDOL8Y
	JZ7caGEFqWITUJP48uUwUIKDQ0QgSmLSMVaQGmaB2UwSUzefB5sqJKAp8WdyK5jNKaAlMX9K
	IxuILSzgLnGs9SsTiM0ioCrx6cllsDivgK3EwRuboWxBiR+T77GA2MxAvet3HmeCsOUlNq95
	ywyyV0JAXeLRX12QsIiAkcSeP1+hSkQk9r14xziBUWgWkkmzkEyahWTSLCQtCxhZVjGKphYk
	FxQnpeca6RUn5haX5qXrJefnbmIEp41n0jsYVzVYHGIU4GBU4uE98C0+SIg1say4MvcQowQH
	s5IIb/GShCAh3pTEyqrUovz4otKc1OJDjMlAj05klhJNzgemtLySeENjEzMjSyMzCyMTc3PS
	hJXEeQ+2WgcKCaQnlqRmp6YWpBbBbGHi4JRqYJQIZT3+QGuOd1t/h9WzOr+lm52mKD+47HM2
	g3FnXDhnayij4sySrOmlvL90GxZ7xip1iOZ5d0fmJyxonu10696iqWd6RWODDIyvlFalSmbx
	fP7LGCh333SJYoHFHKZrpTOif1uYPG3/07Wl7vWBH5O//N4pe/r/rhlGOd8+GXP80j5s/Pvn
	FCWW4oxEQy3mouJEAPdnvVpfAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, October 16, 2013 3:32 PM, Zhenzhong Duan wrote:
> 
> Move default_restore_msi_irqs down to reference msi_mask_irq and msix_mask_irq.
> 
> This patch lays the groundwork for patch titled:
> 'PCI: Refactor MSI/MSIX mask restore code to fix interrupt lost issue'
> 
> Tested-by: Sucheta Chakraborty <sucheta.chakraborty@qlogic.com>
> Signed-off-by: Zhenzhong Duan <zhenzhong.duan@oracle.com>
> Acked-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

Reviewed-by: Jingoo Han <jg1.han@samsung.com>

It looks good. Also, I tested this patch on Exynos5440.

Best regards,
Jingoo Han

