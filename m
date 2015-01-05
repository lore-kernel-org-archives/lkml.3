Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753415AbbAELQV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 06:16:21 -0500
Received: from eusmtp01.atmel.com ([212.144.249.242]:15506 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751511AbbAELQU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 06:16:20 -0500
Message-ID: <54AA7290.7000502@atmel.com>
Date: Mon, 5 Jan 2015 12:16:32 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Paul Bolle <pebolle@tiscali.nl>
CC: Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Valentin Rothberg <valentinrothberg@gmail.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>
Subject: Re: [PATCH 1/4] ARM: at91: remove at91sam9263 legacy board support
References: <cover.1416392687.git.nicolas.ferre@atmel.com> <cf26d39a4a251662dbc363092b319b788d223a7b.1416392687.git.nicolas.ferre@atmel.com> <1417434775.30245.29.camel@x220> <547C92A1.8000902@atmel.com> <1419240528.30945.12.camel@x220> <20141222094512.GA4194@piout.net>
In-Reply-To: <20141222094512.GA4194@piout.net>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 22/12/2014 10:45, Alexandre Belloni a écrit :
> Hi Paul,
> 
> On 22/12/2014 at 10:28:48 +0100, Paul Bolle wrote :
>>> So, I suggest to get rid of them during 3.19-rc phase.
>>
>> There's still an entry for RTC_DRV_AT91SAM9_RTT in next-20141221 (and
>> v3.19-rc1). So this I send this message as a reminder that this cleanup
>> is still needed.
>>
> 
> Thanks for the reminder, the pull request was actually waiting for
> 3.19-rc1 to get released before being sent. This should be solved in the
> next rc.

Yes, a new version of this pull-request has just been sent: ([GIT PULL]
at91: fixes for 3.19 #1 (bis)).

Thanks a lot for the reminder Paul. Bye,
-- 
Nicolas Ferre
