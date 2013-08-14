Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759397Ab3HNHhz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 03:37:55 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:47704 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757957Ab3HNHhx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 03:37:53 -0400
Message-ID: <520B33E3.6030907@atmel.com>
Date: Wed, 14 Aug 2013 09:38:11 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: <dgilbert@interlog.com>, Boris BREZILLON <b.brezillon@overkiz.com>
CC: Andrew Victor <linux@maxim.org.za>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Russell King <linux@arm.linux.org.uk>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM: at91: add missing uart clocks DT entries
References: <1375892984-2835-1-git-send-email-b.brezillon@overkiz.com> <52027B6A.6020306@interlog.com>
In-Reply-To: <52027B6A.6020306@interlog.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/08/2013 18:52, Douglas Gilbert :
> On 13-08-07 12:29 PM, Boris BREZILLON wrote:
>> Add clocks to clock lookup table for uart DT entries.
>>
>> Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
> Tested-by: Douglas Gilbert <dgilbert@interlog.com>

Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>

And stacked on at91-3.11-fixes. I will send it upstream soon (we will 
see if it is accepted for 3.11...).

Thanks, bye,
-- 
Nicolas Ferre
