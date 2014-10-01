Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751647AbaJAKJQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 06:09:16 -0400
Received: from top.free-electrons.com ([176.31.233.9]:33307 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750944AbaJAKJP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 06:09:15 -0400
Message-ID: <542BD2C8.7030304@free-electrons.com>
Date: Wed, 01 Oct 2014 12:09:12 +0200
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: "Miller, Mike (OS Dev)" <Mike.Miller@hp.com>,
        "chirag.kantharia@hp.com" <chirag.kantharia@hp.com>
CC: ISS StorageDev <iss_storagedev@hp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] cpqarray: remove deprecated IRQF_DISABLED
References: <1381551329-6098-1-git-send-email-michael.opdenacker@free-electrons.com> <48275AD710FCA34184C2B6186B4016B32D14B4D5@G6W2491.americas.hpqcorp.net>
In-Reply-To: <48275AD710FCA34184C2B6186B4016B32D14B4D5@G6W2491.americas.hpqcorp.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mike,

On 10/15/2013 12:17 AM, Miller, Mike (OS Dev) wrote:
>
>> -----Original Message-----
>> From: Michael Opdenacker [mailto:michael.opdenacker@free-
>> electrons.com]
>> Sent: Friday, October 11, 2013 11:15 PM
>> To: chirag.kantharia@hp.com
>> Cc: ISS StorageDev; linux-kernel@vger.kernel.org; Michael Opdenacker
>> Subject: [PATCH] cpqarray: remove deprecated IRQF_DISABLED
>>
>> This patch proposes to remove the use of the IRQF_DISABLED flag
>>
>> It's a NOOP since 2.6.35 and it will be removed one day.
> I plan to send a patch soon to remove cpqarray completely.
>
> -- mikem

Any news? Would you like me to take care of this patch if you don't have
time? It would be with pleasure...

Michael.


-- 
Michael Opdenacker, CEO, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
+33 484 258 098

