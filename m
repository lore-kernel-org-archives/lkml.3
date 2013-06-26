Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751517Ab3FZByN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 21:54:13 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:13802 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751426Ab3FZBxj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 21:53:39 -0400
X-AuditID: cbfee68d-b7f096d0000043fc-49-51ca49a12a07
From: Seungwon Jeon <tgih.jun@samsung.com>
To: "'Bing Zhao'" <bzhao@marvell.com>,
        "'Doug Anderson'" <dianders@chromium.org>
Cc: "'Jaehoon Chung'" <jh80.chung@samsung.com>,
        "'Chris Ball'" <cjb@laptop.org>,
        "'Will Newton'" <will.newton@gmail.com>,
        "'Ashok Nagarajan'" <asnagarajan@chromium.org>,
        "'Paul Stewart'" <pstew@chromium.org>,
        "'Olof Johansson'" <olof@lixom.net>, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1363382956-14557-1-git-send-email-dianders@chromium.org>
 <5146EAB0.1030705@samsung.com>
 <CAD=FV=Ww-iK=-vg4jnJe6w4836-yQUoUyxNvCYsDQ5w0q-OMMQ@mail.gmail.com>
 <515E88E3.5070507@samsung.com>
 <003401ce3453$19d1e8c0$4d75ba40$%jun@samsung.com>
 <CAD=FV=V+ZZ0MUtuWKUOgR9NPyAquUjFC6KtHvAP-4iHXAYpjqA@mail.gmail.com>
 <001601ce35b9$652c5870$2f850950$%jun@samsung.com>
 <CAD=FV=XKeRjpH1+ytjMfLuGGqQ5VVub22n=V+UpV=jBCD4LLHw@mail.gmail.com>
 <001801ce6c20$6ba39900$42eacb00$%jun@samsung.com>
 <477F20668A386D41ADCC57781B1F70430EA2AA2513@SC-VEXCH1.marvell.com>
 <CAD=FV=Xz-Cp86u=w8m91AEMJgH-o6cLkz6_udVw_3bm7Tm0OiA@mail.gmail.com>
 <477F20668A386D41ADCC57781B1F70430EA2AA251A@SC-VEXCH1.marvell.com>
 <CAD=FV=V6S7FsK+=+7EHDV74=Mw_iWecO2ZxVpVcd=p7ugW-sHA@mail.gmail.com>
 <477F20668A386D41ADCC57781B1F70430EA2BD5ECB@SC-VEXCH1.marvell.com>
In-reply-to: <477F20668A386D41ADCC57781B1F70430EA2BD5ECB@SC-VEXCH1.marvell.com>
Subject: RE: [PATCH] RFC: mmc: dw_mmc: Always go to STATE_DATA_BUSY from
 STATE_DATA_ERROR
Date: Wed, 26 Jun 2013 10:53:37 +0900
Message-id: <001001ce720f$f96980c0$ec3c8240$%jun@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac5uMCufjr1C5kOuSSelId8rLsG4CADHkr6AAC+YK6A=
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrOIsWRmVeSWpSXmKPExsVy+t8zI92FnqcCDbau17HYvC7eYt7Wo6wW
	219vZLM4u+wgm8WNX22sFpd3zWGzOPK/n9Hi1PXPbBYb7k5ltVi46RCbA5fH7IaLLB47Z91l
	9zh0ZS2jx5UTTawekxdeZPbo27KK0ePzJrkA9igum5TUnMyy1CJ9uwSujAuLf7AWbOSoON2w
	n62B8SJbFyMnh4SAiUT/uvMsELaYxIV764HiXBxCAssYJd5O3s8MU3T22iqoxCJGie6jS6Cc
	P4wSf1YuABvFJqAl8ffNG7AOEQEfibW7vjOBFDELrGSSuD77GBNIQkjgKpvE++6yLkYODk4B
	f4lpe8NAwsIC0RIH2nawg9gsAqoSZztWMYKU8ArYSrz6GQgS5hUQlPgx+R4LSJhZQE/i/kUt
	kDCzgLzE5jVvmUHCEgLqEo/+6kIcYCVx+ucDJogSEYl9L94xghwjITCVQ+L0xZWMEJsEJL5N
	PsQC0SsrsekA1LuSEgdX3GCZwCgxC8niWQiLZyFZPAvJhgWMLKsYRVMLkguKk9KLDPWKE3OL
	S/PS9ZLzczcxQiK9dwfj7QPWhxiTgbZPZJYSTc4HJoq8knhDYzMjC1MTU2Mjc0sz0oSVxHnV
	WqwDhQTSE0tSs1NTC1KL4otKc1KLDzEycXBKNTBGeX+70fmKwYSf/V19kHWR+9JTm4oc5X+8
	9Kxe9MHbSHv3Hp9rvc9PXVJsOvWjgO3j0fnLYxqz8jdxvwkUsC6auPtMR+zn+tsvZ5tyKpWr
	mf0T2VVgsqRt95ZL8Z+W+fw9vkAwif3G71SZY/tWnwtokKn+vCfM47T86Udn17O22B1+Mzk4
	7K6SEktxRqKhFnNRcSIAhiEvDgoDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrCKsWRmVeSWpSXmKPExsVy+t9jAd2FnqcCDaZcUrPYvC7eYt7Wo6wW
	219vZLM4u+wgm8WNX22sFpd3zWGzOPK/n9Hi1PXPbBYb7k5ltVi46RCbA5fH7IaLLB47Z91l
	9zh0ZS2jx5UTTawekxdeZPbo27KK0ePzJrkA9qgGRpuM1MSU1CKF1Lzk/JTMvHRbJe/geOd4
	UzMDQ11DSwtzJYW8xNxUWyUXnwBdt8wcoPuUFMoSc0qBQgGJxcVK+naYJoSGuOlawDRG6PqG
	BMH1GBmggYR1jBkXFv9gLdjIUXG6YT9bA+NFti5GTg4JAROJs9dWQdliEhfurQeyuTiEBBYx
	SnQfXQLl/GGU+LNyAVgVm4CWxN83b5hBbBEBH4m1u74zgRQxC6xkkrg++xgTSEJI4CqbxPvu
	si5GDg5OAX+JaXvDQMLCAtESB9p2sIPYLAKqEmc7VjGClPAK2Eq8+hkIEuYVEJT4MfkeC0iY
	WUBP4v5FLZAws4C8xOY1b5lBwhIC6hKP/upCHGAlcfrnAyaIEhGJfS/eMU5gFJqFZNAshEGz
	kAyahaRjASPLKkbR1ILkguKk9FwjveLE3OLSvHS95PzcTYzgNPJMegfjqgaLQ4wCHIxKPLwK
	W08GCrEmlhVX5h5ilOBgVhLhzb8BFOJNSaysSi3Kjy8qzUktPsSYDPTlRGYp0eR8YIrLK4k3
	NDYxM7I0MrMwMjE3J01YSZz3YKt1oJBAemJJanZqakFqEcwWJg5OqQbGWqMzESYHVO0bbKed
	2qI1I+vn7eR1oveYK13uMbV0hW+6srTnllZ/kH1I+FQj3a8pG1g7czfd023Zxj5LJLE8XcvR
	J+XKEtW5gWcZuswsXzDdXbqP9Yb05/lROhfdYuq/qqZuFHXbkF7i7RiyLLX8YyXXoemSf5Mf
	Kx168k1om0u7mta0r2xKLMUZiYZazEXFiQAvfPoRZwMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jaehoon,
Do you have the same result?
Could you share the result?

Thanks,
Seungwon Jeon
On Tuesday, June 25 2013, Bing Zhao wrote:
> > I think the proposal on the table is to take Seungwon's patches
> > instead of mine.  Assuming they solve your problems, I'm OK with that.
> >  I think he was requesting testing the first of his two patches alone
> > and then both of his two patches together.
> 
> Test #1: Swungwon's patch #1 alone [1]
> Test #2: Swungwon's patch #2 alone [1]
> Test #3: Swungwon's patch #1 and #2 [1]
> Test #4: Doug's original patch [2]
> 
> Test #1 and #3: it doesn't work; system reboots due to kernel hung_task
> Test #2 and #4: it works; instead of hung_task driver gets CRC error (which is expected)
> 
> Thanks,
> Bing
> 
> [1] https://lkml.org/lkml/2013/4/8/316
> [2] https://lkml.org/lkml/2013/3/15/583
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

