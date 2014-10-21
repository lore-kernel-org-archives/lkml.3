Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932965AbaJUOVI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 10:21:08 -0400
Received: from down.free-electrons.com ([37.187.137.238]:58565 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932702AbaJUOVF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 10:21:05 -0400
Message-ID: <54466B73.3090704@free-electrons.com>
Date: Tue, 21 Oct 2014 11:19:31 -0300
From: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Jason Cooper <jason@lakedaemon.net>, Grzegorz Jaszczyk <jaz@semihalf.com>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        tglx@linutronix.de, gregory.clement@free-electrons.com,
        thomas.petazzoni@free-electrons.com, alior@marvell.com,
        tawfik@marvell.com, mw@semihalf.com
Subject: Re: [PATCH 0/2] Marvell Armada 375/38x MPIC/MSI fixes
References: <1411643839-64925-1-git-send-email-jaz@semihalf.com> <20141003135017.GH3895@titan.lakedaemon.net>
In-Reply-To: <20141003135017.GH3895@titan.lakedaemon.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/03/2014 10:50 AM, Jason Cooper wrote:
> On Thu, Sep 25, 2014 at 01:17:17PM +0200, Grzegorz Jaszczyk wrote:
>> This patchset contains a set of fixes for issues found while doing some test
>> with different interrupts configuration on Armada 375 and Armada 38x Marvell
>> SoCs. The patches were tested and apply on v3.17-rc6.
>>
>> Any feedback is welcome.
>>
>> Grzegorz Jaszczyk (2):
>>   irqchip: armada-370-xp: fix MSI interrupt handling
>>   irqchip: armada-370-xp: fix MPIC interrupt handling
>>
>>  drivers/irqchip/irq-armada-370-xp.c | 23 +++++++++++++++++------
>>  1 file changed, 17 insertions(+), 6 deletions(-)
> 
> Ah crap.  This slipped off my plate.  Sorry about that.  I've now
> applied these to irqchip/urgent with Ezequiel's Ack.  I'll get them into
> -next and hopefully do a PR toward the end of next week.
> 

Jason,

The patches don't seem to be in v3.18-rc1 for some reason.

I can't seem to find your PR (probably because I've switched to
Thunderbird now
and it's a pain to search mails properly).

Since this is an important fix, maybe you can schedule it for -rc2?

Thanks!
-- 
Ezequiel García, Free Electrons
Embedded Linux, Kernel and Android Engineering
http://free-electrons.com
