Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754813AbaEHRTl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 13:19:41 -0400
Received: from top.free-electrons.com ([176.31.233.9]:40159 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752428AbaEHRTk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 13:19:40 -0400
Message-ID: <536BBCAA.6020309@free-electrons.com>
Date: Thu, 08 May 2014 19:19:38 +0200
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Mark Roszko <mark.roszko@gmail.com>,
        Bryan Evenson <bevenson@melinkcorp.com>
CC: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Andrew Victor <linux@maxim.org.za>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM: at91: fix rtc irq mask for sam9x5 SoCs
References: <957b209589094df48ddedbc57c6ccdfd@BLUPR05MB037.namprd05.prod.outlook.com> <1399479649-3247-1-git-send-email-boris.brezillon@free-electrons.com> <edaf5835a7b14b9a8c053dcd40f2b591@BLUPR05MB037.namprd05.prod.outlook.com> <CAJjB1q+sZvJ=VDFsZJyvqSiOa=zapmnzkAvY1pW2KwjZK4uaKg@mail.gmail.com>
In-Reply-To: <CAJjB1q+sZvJ=VDFsZJyvqSiOa=zapmnzkAvY1pW2KwjZK4uaKg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 08/05/2014 05:10, Mark Roszko wrote:
> Atmel actually has this issue in the Errata of the SAM9G25 and SAM9G35
> datasheets which might be worth referencing in the description?
>
>> 49.7.1 RTC: Interrupt Mask Register cannot be used
>> Interrupt Mask Register read always returns 0.

Sure, I'll quote atmel's datasheet and state that it only impacts
sam9g25 and g35 SoCs.

Thanks,

Boris


-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com

