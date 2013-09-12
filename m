Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756851Ab3ILIKT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 04:10:19 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:45104 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751276Ab3ILIKQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 04:10:16 -0400
X-AuditID: cbfee68e-b7f756d000004512-43-523176d6b12c
From: Jingoo Han <jg1.han@samsung.com>
To: "'Michael Opdenacker'" <michael.opdenacker@free-electrons.com>,
        davem@davemloft.net
Cc: richardcochran@gmail.com, jiri@resnulli.us, mugunthanvnm@ti.com,
        uclinux-dist-devel@blackfin.uclinux.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1378956943-3470-1-git-send-email-michael.opdenacker@free-electrons.com>
In-reply-to: <1378956943-3470-1-git-send-email-michael.opdenacker@free-electrons.com>
Subject: Re: [PATCH] bfin_mac: remove deprecated IRQF_DISABLED
Date: Thu, 12 Sep 2013 17:09:58 +0900
Message-id: <000101ceaf8f$795f5cc0$6c1e1640$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac6vaTER3B7wSB4VSDKUv/xcupjEwwAJhn/w
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrJIsWRmVeSWpSXmKPExsVy+t8zA91rZYZBBks2aVnMOd/CYnHxarrF
	5V1z2CweTFjFZnH1QbnFsQViFkfOvGC2WNjwhd2Bw2PldG+PLStvMnk82XSR0WPnrLvsHldv
	Vnscv7GdyePzJrkA9igum5TUnMyy1CJ9uwSujNaFrSwF/5krmu5eZ21gXMDcxcjJISFgIvHv
	UA8bhC0mceHeeiCbi0NIYBmjRMuCPvYuRg6woqUPSyDi0xklTu5cDNYgJPCLUeJcZyyIzSag
	JvHly2F2EFtEIFziSvs2FpAGZpBB7VvuQTWESSw92M8IMpQTqOhnQzhIWFjATmLVmTawg1gE
	VCVu/28EK+cVsJVY9eAoE4QtKPFj8j0WEJtZQEti/c7jTBC2vMTmNW+ZIe5Ul3j0VxfiBCOJ
	GQfPQJWISOx78Y4R4se/7BIrHpVDrBKQ+Db5EAtEq6zEpgPQIJGUOLjiBssERolZSBbPQrJ4
	FpLFs5BsWMDIsopRNLUguaA4Kb3ISK84Mbe4NC9dLzk/dxMjJJr7djDePGB9iDEZaP1EZinR
	5HxgMsgriTc0NjOyMDUxNTYytzQjTVhJnFetxTpQSCA9sSQ1OzW1ILUovqg0J7X4ECMTB6dU
	A2N0WfrL4CWSE2dbVYQbq7VtzVugEPOtn7Xq56OHGTqWZ0o/S207Pu3Eyu8xcaZHXYJVfr0Q
	v7J96/Y/N1zVn1fN150gxvgu5sMhuQC+xCfbdk1esU2+2Vgl1XbG3R2vOwSfm0UF8d/pfvWN
	QXTuvK+3pdXYj7jOmf96+TLOc6Kno92lRROCn7YqsRRnJBpqMRcVJwIASg0uEPwCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrOKsWRmVeSWpSXmKPExsVy+t9jQd1rZYZBBmv+q1rMOd/CYnHxarrF
	5V1z2CweTFjFZnH1QbnFsQViFkfOvGC2WNjwhd2Bw2PldG+PLStvMnk82XSR0WPnrLvsHldv
	Vnscv7GdyePzJrkA9qgGRpuM1MSU1CKF1Lzk/JTMvHRbJe/geOd4UzMDQ11DSwtzJYW8xNxU
	WyUXnwBdt8wcoIuUFMoSc0qBQgGJxcVK+naYJoSGuOlawDRG6PqGBMH1GBmggYR1jBmtC1tZ
	Cv4zVzTdvc7awLiAuYuRg0NCwERi6cOSLkZOIFNM4sK99WxdjFwcQgLTGSVO7lzMBpIQEvjF
	KHGuMxbEZhNQk/jy5TA7iC0iEC5xpX0bC0gDs8AyRon2LfegGsIklh7sZwRZwAlU9LMhHCQs
	LGAnsepMGzOIzSKgKnH7fyNYOa+ArcSqB0eZIGxBiR+T77GA2MwCWhLrdx5ngrDlJTaveQt1
	s7rEo7+6ECcYScw4eAaqRERi34t3jBMYhWYhmTQLyaRZSCbNQtKygJFlFaNoakFyQXFSeq6R
	XnFibnFpXrpecn7uJkZwsngmvYNxVYPFIUYBDkYlHt6OWQZBQqyJZcWVuYcYJTiYlUR4480N
	g4R4UxIrq1KL8uOLSnNSiw8xJgM9OpFZSjQ5H5jI8kriDY1NzIwsjcwsjEzMzUkTVhLnPdhq
	HSgkkJ5YkpqdmlqQWgSzhYmDU6qBUS4x5mfXsSt7bznP2LI3S3xqs/XhdzmO8/PVmE0Lu883
	T7uqKCXYNXXnLc6LKU+3z+1TOrhk16yz76bsjlp9a7t7Ewtj0w6HU1bzp+7lfGRbUP27luP4
	xPz3THkXrtXPeiW04vdi03maHqEW0aItC/7lpGRtevz92oSDM+7Nf5HuH7l4+t+nOcxKLMUZ
	iYZazEXFiQCqlaH4WgMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, September 12, 2013 12:36 PM, Michael Opdenacker wrote:
> 
> This patch proposes to remove the IRQF_DISABLED flag from
> drivers/net/ethernet/adi/bfin_mac.c.
> 
> It's a NOOP since 2.6.35 and it will be removed one day.
> 
> Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>

Reviewed-by: Jingoo Han <jg1.han@samsung.com>

Best regards,
Jingoo Han

> ---
>  drivers/net/ethernet/adi/bfin_mac.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)


