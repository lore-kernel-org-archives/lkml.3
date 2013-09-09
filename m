Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752646Ab3IIDwi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Sep 2013 23:52:38 -0400
Received: from top.free-electrons.com ([176.31.233.9]:52624 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752262Ab3IIDwh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Sep 2013 23:52:37 -0400
Message-ID: <522D4603.4000907@free-electrons.com>
Date: Mon, 09 Sep 2013 05:52:35 +0200
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Ramkumar Ramachandra <artagnon@gmail.com>
CC: konrad.wilk@oracle.com, boris.ostrovsky@oracle.com,
        david.vrabel@citrix.com, xen-devel@lists.xenproject.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] xen: remove deprecated IRQF_DISABLED
References: <1378696187-4359-1-git-send-email-michael.opdenacker@free-electrons.com> <CALkWK0mgk4ryO6h=CrWDjQ2bFtg=YY7dS1pJ1JqgX2Oo04wD8Q@mail.gmail.com>
In-Reply-To: <CALkWK0mgk4ryO6h=CrWDjQ2bFtg=YY7dS1pJ1JqgX2Oo04wD8Q@mail.gmail.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/09/2013 05:22 AM, Ramkumar Ramachandra wrote:
> Michael Opdenacker wrote:
>> diff --git a/drivers/xen/platform-pci.c b/drivers/xen/platform-pci.c
>> index 99db9e1..2f3528e 100644
>> --- a/drivers/xen/platform-pci.c
>> +++ b/drivers/xen/platform-pci.c
>> @@ -84,7 +84,7 @@ static irqreturn_t do_hvm_evtchn_intr(int irq, void *dev_id)
>>  static int xen_allocate_irq(struct pci_dev *pdev)
>>  {
>>         return request_irq(pdev->irq, do_hvm_evtchn_intr,
>> -                       IRQF_DISABLED | IRQF_NOBALANCING | IRQF_TRIGGER_RISING,
>> +                       IRQF_NOBALANCING | IRQF_TRIGGER_RISING,
> This is a good patch, although that one day might be far in the future.
Yes, it might be relatively far... IRQF_DISABLED still shows up 331
times in the kernel sources.

It's hard to disable ;)

Cheers,

Michael.

-- 
Michael Opdenacker, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
+33 484 258 098

