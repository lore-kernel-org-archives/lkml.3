Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966271AbaFRLb7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 07:31:59 -0400
Received: from mail.dev.rtsoft.ru ([213.79.90.226]:48998 "EHLO dev.rtsoft.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933954AbaFRLb6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 07:31:58 -0400
Message-ID: <53A178AD.3060003@dev.rtsoft.ru>
Date: Wed, 18 Jun 2014 15:31:57 +0400
From: Nikita Yushchenko <nyushchenko@dev.rtsoft.ru>
Organization: RTSoft Software Development Center
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Lee Jones <lee.jones@linaro.org>
CC: Grant Likely <grant.likely@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, lugovskoy@dev.rtsoft.ru
Subject: Re: [PATCH 11/21] mfd: use devm_irq_of_parse_and_map() where appropriate
References: <1401880402-30091-1-git-send-email-nyushchenko@dev.rtsoft.ru> <1401880402-30091-12-git-send-email-nyushchenko@dev.rtsoft.ru> <20140617151226.GM29841@lee--X1> <53A0606C.6030400@dev.rtsoft.ru> <20140618084838.GR21030@lee--X1>
In-Reply-To: <20140618084838.GR21030@lee--X1>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> Hmm...  probably it was too early to apply this?  I was just going
>> to prepare v2, based on discussion...
>
> Which discussion?

One you are replying in?

https://lkml.org/lkml/2014/6/4/136

>> Also, applying only 11/21, without 01/21, will just cause build errors ...
>
> CC'ing me on this patch alone when you know you have build
> dependencies on other patches in the set is a bad idea.  Failing to
> mention that you wanted the patch to be handled in a special and/or
> unconventional way is an even worse idea.
>
> How are you expecting this patch(-set) to be handled?

Sorry but I did not CC you this patch.

I sent entire patchset to mailing lists and to maintainers of IRQ and 
device tree subsystems.
I used git send-email, and all mails went out to the same recipients.
Recipient addresses extracted using scripts/get_maintainer.pl applied to 
the "main" patch of the patchset.
I did not sent entire patchset to maintainers of individual changed 
drivers because this makes recipient address too big and too much looks 
like spamming.
I did not send individual patches to individual addresses to avoid cases 
of partially-applied patchset that will just break things (actually this 
is what happened with 11/21)

I'm quite sorry if I did things wrong, it was my first attempt to sent 
patchset with tree-wide fixes. However, I don't see what I've done 
wrong... any hints on that will be appreciated.

Nikita

