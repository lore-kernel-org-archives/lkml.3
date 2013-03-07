Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758478Ab3CGAuV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 19:50:21 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:29658 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753867Ab3CGAuT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 19:50:19 -0500
X-AuditID: cbfee691-b7faa6d000005ae9-c5-5137e449d4c0
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Paul Bolle'" <pebolle@tiscali.nl>
Cc: "'Ben Dooks'" <ben-linux@fluff.org>,
        "'Russell King'" <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1362609234.28137.2.camel@x61.thuisdomein>
 <013a01ce1ac7$11b287d0$35179770$%kim@samsung.com>
 <1362615081.28137.5.camel@x61.thuisdomein>
In-reply-to: <1362615081.28137.5.camel@x61.thuisdomein>
Subject: RE: [PATCH] ARM: S3C24XX: drop "select MACH_N35"
Date: Thu, 07 Mar 2013 09:50:17 +0900
Message-id: <014601ce1acd$bc63d480$352b7d80$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4ayE238uCiY68OQ9qzdwj37odLJAABUUdg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrBIsWRmVeSWpSXmKPExsVy+t8zfV3PJ+aBBvP3qFtMWneAyWLT42us
	Fpd3zWGzmHF+H5PF7cu8FotunWF2YPNoae5h8/i76gWzx+Yl9R4btz9h8vi8SS6ANYrLJiU1
	J7MstUjfLoEr4/DHtWwFe5gr2r49YW9gPMHUxcjBISFgIrF8tWIXIyeQKSZx4d56ti5GLg4h
	gWWMEtemnGGDqVnXywQRn84ocfjHNnaQBiGBv4wSf7oCQGw2AQ2Jw++fgcVFBFQlNn7+wAzS
	wCywk1Gi+cZzhO71j5eAVXEKmEv8edEPZgsLWEq8WnGTFcRmAer+8HodmM0rYCvx4uoOJghb
	UOLH5HssIBcxC6hLTJmSCxJmFpCX2LzmLTPEoeoSj/7qQtxgJPH76TdmiBIRiX0v3jGCnCAh
	cI9dYtny7+wQqwQkvk0+xALRKyux6QAzJCAkJQ6uuMEygVFiFpLFsxAWz0KyeBaSDQsYWVYx
	iqYWJBcUJ6UXmeoVJ+YWl+al6yXn525ihMTqxB2M9w9YH2JMBto+kVlKNDkfGOt5JfGGxsYm
	ZiamJuaWpuampAkrifPKX5IJFBJITyxJzU5NLUgtii8qzUktPsTIxMEp1cBoNFur61zr+0me
	1apnGuqab1QGCy9hvfd7iqXlRb4wjgenJyWFucW8/bH7fkWFosaaT/av5i6VZNQ5veFw8/Nc
	7wrlJZri0q1V8zqWTGdfti7l1LSk8qZbX/Zc+yhyLUGveJlw2Mo5gpMPMprcaS1bcjHG2fjo
	68V5y46ICVazflFmfD1pxZWrSizFGYmGWsxFxYkA8Zp4MOsCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrGKsWRmVeSWpSXmKPExsVy+t9jQV3PJ+aBBt3nlSwmrTvAZLHp8TVW
	i8u75rBZzDi/j8ni9mVei0W3zjA7sHm0NPewefxd9YLZY/OSeo+N258weXzeJBfAGtXAaJOR
	mpiSWqSQmpecn5KZl26r5B0c7xxvamZgqGtoaWGupJCXmJtqq+TiE6DrlpkDdICSQlliTilQ
	KCCxuFhJ3w7ThNAQN10LmMYIXd+QILgeIwM0kLCOMePwx7VsBXuYK9q+PWFvYDzB1MXIwSEh
	YCKxrhfI5AQyxSQu3FvP1sXIxSEkMJ1R4vCPbewgCSGBv4wSf7oCQGw2AQ2Jw++fgcVFBFQl
	Nn7+wAzSwCywk1Gi+cZzJrju9Y+XgFVxCphL/HnRD2YLC1hKvFpxkxXEZgHq/vB6HZjNK2Ar
	8eLqDiYIW1Dix+R7LCDXMQuoS0yZkgsSZhaQl9i85i0zxNHqEo/+6kLcYCTx++k3ZogSEYl9
	L94xTmAUmoVk0CyEQbOQDJqFpGMBI8sqRtHUguSC4qT0XEO94sTc4tK8dL3k/NxNjOBU8Exq
	B+PKBotDjAIcjEo8vBz55oFCrIllxZW5hxglOJiVRHjvLgEK8aYkVlalFuXHF5XmpBYfYkwG
	enMis5Rocj4wTeWVxBsam5gZWRqZWRiZmJuTJqwkzst46kmAkEB6YklqdmpqQWoRzBYmDk6p
	BsbQI7M3P03dZru5eOWHE9q+vBWWu31/uFou3/a1P2Vm/GoxTUP511tNm1z8/a9KMrEvvPlM
	47a66u7+S8kWW4P8l4k3n6xRmZylmr/ZdYax6rtrlYwXHnPe2Xt3gqpv+oqZQY685jVqQXxZ
	Kc+PHY44nWR8+3+N1lnOr/YOlycsLppi9UGYe5ESS3FGoqEWc1FxIgBnG7WnSQMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Bolle wrote:
> 
> On Thu, 2013-03-07 at 09:02 +0900, Kukjin Kim wrote:
> 
> > BTW, so the machine type can be removed at arch/arm/tools/mach-types as
> well.
> 
> Well, that file has a big comment on top, containing the line:
>     Please do not send patches to this file; it is automatically
> generated!
> 
> So I didn't dare to touch it.
> 
Yeah, I know.

It will be handled by Russell King :-)

Thanks.

- Kukjin

