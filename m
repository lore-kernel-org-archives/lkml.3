Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751819AbaLPSYr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 13:24:47 -0500
Received: from mail-ie0-f171.google.com ([209.85.223.171]:34801 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751785AbaLPSYq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 13:24:46 -0500
Message-ID: <549078EC.5030007@gmail.com>
Date: Tue, 16 Dec 2014 10:24:44 -0800
From: David Daney <ddaney.cavm@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Aaro Koskinen <aaro.koskinen@iki.fi>
CC: Aleksey Makarov <feumilieu@gmail.com>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org, David Daney <david.daney@cavium.com>,
        Aleksey Makarov <aleksey.makarov@auriga.com>,
        Ralf Baechle <ralf@linux-mips.org>
Subject: Re: [PATCH 12/14] MIPS: OCTEON: Update octeon-model.h code for new
 SoCs.
References: <1418666603-15159-1-git-send-email-aleksey.makarov@auriga.com> <1418666603-15159-13-git-send-email-aleksey.makarov@auriga.com> <20141215210148.GB10323@fuloong-minipc.musicnaut.iki.fi>
In-Reply-To: <20141215210148.GB10323@fuloong-minipc.musicnaut.iki.fi>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/15/2014 01:01 PM, Aaro Koskinen wrote:
> Hi,
>
> On Mon, Dec 15, 2014 at 09:03:18PM +0300, Aleksey Makarov wrote:
>> From: David Daney <david.daney@cavium.com>
>>
>> Add coverage for OCTEON III models.
>
> [...]
>
>> +#define OCTEON_IS_OCTEON1()	OCTEON_IS_MODEL(OCTEON_CN3XXX)
>> +#define OCTEON_IS_OCTEONPLUS()	OCTEON_IS_MODEL(OCTEON_CN5XXX)
>> +#define OCTEON_IS_OCTEON2()						\
>> +	(OCTEON_IS_MODEL(OCTEON_CN6XXX) || OCTEON_IS_MODEL(OCTEON_CNF71XX))
>> +
>> +#define OCTEON_IS_OCTEON3()	OCTEON_IS_MODEL(OCTEON_CN7XXX)
>> +
>> +#define OCTEON_IS_OCTEON1PLUS()	(OCTEON_IS_OCTEON1() || OCTEON_IS_OCTEONPLUS())
>
> There are no users for these.
>

True, but we will soon be adding users, so we would like to keep them.

David Daney

> A.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
>

