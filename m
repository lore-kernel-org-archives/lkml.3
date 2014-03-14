Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756378AbaCNRSm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 13:18:42 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:47000 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755344AbaCNRSk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 13:18:40 -0400
X-AuditID: cbfec7f5-b7fc96d000004885-6c-532339ed9830
Message-id: <532339EB.5090304@samsung.com>
Date: Fri, 14 Mar 2014 18:18:35 +0100
From: Tomasz Figa <t.figa@samsung.com>
Organization: Samsung R&D Institute Poland
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.3.0
MIME-version: 1.0
To: Yuvaraj Kumar <yuvaraj.cd@gmail.com>,
        "kgene.kim@samsung.com" <kgene.kim@samsung.com>,
        linux-kernel@vger.kernel.org,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linux-doc@vger.kernel.org
Cc: Grant Likely <grant.likely@linaro.org>, Jingoo Han <jg1.han@samsung.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Mark Rutland <mark.rutland@arm.com>, sunil joshi <joshi@samsung.com>,
        "ks.giri@samsung.com" <ks.giri@samsung.com>, thomas.ab@samsung.com,
        Yuvaraj Kumar C D <yuvaraj.cd@samsung.com>
Subject: Re: [PATCH] ARM: dts: exynos5250: turn on the LDO10 on SMDK5250
References: <1393845310-1898-1-git-send-email-yuvaraj.cd@samsung.com>
 <CAKuRcO+vudiKC1SRGMWgb3Ec0-JrVNeCxM5g5eTNR3OnQmmMTQ@mail.gmail.com>
In-reply-to: <CAKuRcO+vudiKC1SRGMWgb3Ec0-JrVNeCxM5g5eTNR3OnQmmMTQ@mail.gmail.com>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrJLMWRmVeSWpSXmKPExsVy+t/xa7pvLZWDDV7PEbOYf+Qcq8WBPzsY
	LS4vvMRq8X3XF3aL3gVX2SzmH93BZLGwbQmLxeVdc9gsll6/yGTx6mAbi0XHMkaLh0e7WS3O
	nip34PVYM28No8fOWXfZPe5c28Pm0bdlFaPH501yHhvnhgawRXHZpKTmZJalFunbJXBlTJy0
	jr2ghbXi3Zt1jA2MbSxdjJwcEgImEtvX/meHsMUkLtxbzwZiCwksZZRYuSisi5ELyP7MKNE+
	vZUZJMEroCWx+t9joAYODhYBVYmZm91BwmwCahKfGx6B9fIDlaxpug42X1QgQmLuxM1sEK2C
	Ej8m3wOLiwhcZpRomhILMp9ZYAOTxJ5PG5hAEsICHhL/P6xggjiiB2jxe34Qm1MgWGJPI8QN
	zALWEisnbWOEsOUlNq95yzyBUXAWkh2zkJTNQlK2gJF5FaNoamlyQXFSeq6RXnFibnFpXrpe
	cn7uJkZI9Hzdwbj0mNUhRgEORiUeXg1V5WAh1sSy4srcQ4wSHMxKIrz7jYFCvCmJlVWpRfnx
	RaU5qcWHGJk4OKUaGOX8T7/6fst8Qvb+jnv5LBfzPnGWaAk+KN1z45fYW8b+O5fv2/ctstnT
	taHeeOn0IwKMus/PX+FgZT8dX3l0+v+jz7buN5x+/o7plp77N/flLprO9mBec4HEp4NPnx47
	WXg7b95CsS2HZMM2zT5/hWn5r9emUxVlxETOn4j+LfHQkPnmB8+jWivKlFiKMxINtZiLihMB
	xs7hjXwCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Yuvaraj,

On 14.03.2014 09:26, Yuvaraj Kumar wrote:
> Any comments on this?
>
> On Mon, Mar 3, 2014 at 4:45 PM, Yuvaraj Kumar C D <yuvaraj.cd@gmail.com> wrote:
>> Commit 275dcd2 "ARM: dts: add max77686 pmic node for smdk5250" added
>> required LDO's for SMDK5250 boards.Currently LDO10 is turned off.As LDO10,
>> enable/disable the LDO22 which is required for VDDQ_MMC2_AP.So this patch
>> makes LDO10 turn's on always.

This does not seem right to me. Why a regulator used by MMC should be 
always enabled? Shouldn't it be specified as one of the MMC regulators 
in corresponding MMC controller node?

Best regards,
Tomasz
