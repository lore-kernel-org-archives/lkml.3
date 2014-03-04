Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757308AbaCDVXv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 16:23:51 -0500
Received: from top.free-electrons.com ([176.31.233.9]:44516 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756767AbaCDVXt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 16:23:49 -0500
Message-ID: <53164463.5080502@free-electrons.com>
Date: Tue, 04 Mar 2014 22:23:47 +0100
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: "Miller, Mike (OS Dev)" <Mike.Miller@hp.com>,
        "chirag.kantharia@hp.com" <chirag.kantharia@hp.com>
CC: ISS StorageDev <iss_storagedev@hp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] cpqarray: remove deprecated IRQF_DISABLED
References: <1381551329-6098-1-git-send-email-michael.opdenacker@free-electrons.com> <48275AD710FCA34184C2B6186B4016B32D14B4D5@G6W2491.americas.hpqcorp.net>
In-Reply-To: <48275AD710FCA34184C2B6186B4016B32D14B4D5@G6W2491.americas.hpqcorp.net>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Mike,

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
Any news from this removal? I would like to get rid of my patch for good...

Thank you in advance,

Michael.

-- 
Michael Opdenacker, CEO, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
+33 484 258 098

