Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757817Ab3JOGNB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 02:13:01 -0400
Received: from mail-oa0-f50.google.com ([209.85.219.50]:49262 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751258Ab3JOGM6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 02:12:58 -0400
MIME-Version: 1.0
In-Reply-To: <525CDB51.70408@denx.de>
References: <1380799354-14460-1-git-send-email-ch.naveen@samsung.com>
 <1381813971-16006-1-git-send-email-ch.naveen@samsung.com> <525CDB51.70408@denx.de>
From: Naveen Krishna Ch <naveenkrishna.ch@gmail.com>
Date: Tue, 15 Oct 2013 11:42:37 +0530
Message-ID: <CAHfPSqDxSGFaBDAMQD7Xz3J+jNtMdcEuF8uFdjLBP8p1G1DsMw@mail.gmail.com>
Subject: Re: [PATCH 1/3 v3] exynos: i2c: Fix i2c driver to handle NACKs properly
To: hs@denx.de
Cc: Naveen Krishna Chatradhi <ch.naveen@samsung.com>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        khali@linux-fr.org, Ben Dooks <ben-linux@fluff.org>,
        grant.likely@secretlab.ca, sjg@chromium.org, d.mueller@elsoft.ch,
        trini@ti.com, Minkyu Kang <mk7.kang@samsung.com>, cpgs@samsung.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15 October 2013 11:36, Heiko Schocher <hs@denx.de> wrote:
> Hello Naveen,
>
> Am 15.10.2013 07:12, schrieb Naveen Krishna Chatradhi:
>
>> The Exynos5 i2c driver does not handle NACKs properly. This change:
>>
>> - fixes the NACK processing problem (do not continue transaction if
>>    address cycle was NACKed)
>>
>> - eliminates a fair amount of duplicate code
>>
>> Signed-off-by: Vadim Bendebury<vbendeb@chromium.org>
>> Reviewed-by: Simon Glass<sjg@google.com>
>> Signed-off-by: Naveen Krishna Chatradhi<ch.naveen@samsung.com>
>> ---
>> Changes since v1:
>> Fixed complilation warning in function i2c_init()
>>
>> Changes since v2:
>> None
>>
>>   drivers/i2c/s3c24x0_i2c.c |  214
>> +++++++++++++++++++--------------------------
>>   1 file changed, 90 insertions(+), 124 deletions(-)
>
>
> Hmm.. I think your patchset is for u-boot, or? But I could not find
> the u-boot ml on cc... instead some linux ml ... if so, please resend
> to the u-boot ml ...
>
> (matches for all three patches from you)
I just checked that u-boot mailing list is missing.
I've done the checks you mentioned in the other mail and reposted with
u-boot@lists.denx.de in --to

Thanks for your review.
>
>
> bye,
> Heiko
> --
> DENX Software Engineering GmbH,     MD: Wolfgang Denk & Detlev Zundel
> HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany



-- 
Shine bright,
(: Nav :)
