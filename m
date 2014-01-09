Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756089AbaAIMyH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 07:54:07 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:34572 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755245AbaAIMxH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 07:53:07 -0500
X-AuditID: cbfee61b-b7f456d000006dfd-d4-52ce9bb1fad5
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Mj Embd <mj.embd@gmail.com>
Cc: linaro-kernel <linaro-kernel@lists.linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-samsung-soc@vger.kernel.org
Subject: Re: Arndale Timer Interrupt Question
Date: Thu, 09 Jan 2014 13:52:46 +0100
Message-id: <1437466.9hkS4zH5MN@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-54-generic-pae; KDE/4.8.5; i686; ; )
In-reply-to: <CAPUj1OM=Zn2nd98aXRCRUJrLknkS0o44V1BfuJhz5i19w+M5Ow@mail.gmail.com>
References: <CAPUj1OM=Zn2nd98aXRCRUJrLknkS0o44V1BfuJhz5i19w+M5Ow@mail.gmail.com>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=UTF-8
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrMLMWRmVeSWpSXmKPExsVy+t9jAd2Ns88FGaw7LG3x/tAzZovLu+aw
	Wcw4v4/J4kDPITYHFo+ds+6ye9z+95jZ4/MmuQDmKC6blNSczLLUIn27BK6Mg40HmAoaWSvm
	dM5namB8xdzFyMkhIWAi8WzKB3YIW0ziwr31bF2MXBxCAosYJfZf72CCcFqYJDpefWMBqWIT
	sJKY2L6KEcQWEZCXuPSlkRGkiFlgBqPEjL/P2EASwgK6Es+/XANbwSKgKvH9xEImEJtXQFNi
	xqU5YOtEBTwldmxfCVTPwcEpECzx83MeSFhIIEBi0fXHjBDlghI/Jt8D28sMtGvf/qmsELa6
	xKR5i5gnMArMQlI2C0nZLCRlCxiZVzGKphYkFxQnpeca6RUn5haX5qXrJefnbmIEB+0z6R2M
	qxosDjEKcDAq8fCuKD4bJMSaWFZcmXuIUYKDWUmEd2rjuSAh3pTEyqrUovz4otKc1OJDjNIc
	LErivAdbrQOFBNITS1KzU1MLUotgskwcnFINjL2OIZP+5s0977mq5t2r3vTT15/eE+I5qSrg
	su6tq2fwme1VKp4fM3ksnwbtZ3xuy7KLPWhWZcqf5QW9chcz/LZ0nq/jEznoEvhO0Cfexkno
	dtgKibyr656Uzrn6IfDY812zhFpMN+070Jp29Jnela59FaalL/+VqO84nibRH1z3IMHs54sm
	BiWW4oxEQy3mouJEAACgxihWAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


added linux-samsung-soc to cc:,
it is a better suited list for this question

On Thursday, January 09, 2014 10:30:56 AM Mj Embd wrote:
> I am a bit confused on the interrupt number for CNTVIRQ..CNTHPIRQ. Can
> you please help here.
> 
> As per the exynos5 public manual
> What is the difference between  CPU_nCNTHPIRQ[0] and CNTHPIRQ.
> 
> While the later has an interrupt ID 26, the former is part of a group
> with combined interrupt id as 33 for core 0 and 54 for core 1.
> 
> For a timer interrupt which goes to PL2, which id should be used 26 or
> 33 for core 0 ?
> 
> Please clear this confusion.
> 
> Many Thanks

