Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755103Ab3CHUAp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 15:00:45 -0500
Received: from mail-ia0-f174.google.com ([209.85.210.174]:58890 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751136Ab3CHUAo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 15:00:44 -0500
MIME-Version: 1.0
In-Reply-To: <20130308195055.GD6622@phenom.dumpdata.com>
References: <1360351703-20571-1-git-send-email-yinghai@kernel.org>
	<1360351703-20571-11-git-send-email-yinghai@kernel.org>
	<20130308195055.GD6622@phenom.dumpdata.com>
Date: Fri, 8 Mar 2013 12:00:43 -0800
X-Google-Sender-Auth: KvKD6PUQzsnQiDo1EmLh47QVXZc
Message-ID: <CAE9FiQXZAdndUMEH-yBOvvx2jSMC3tQqs73LmdaY_ni+W=nFHw@mail.gmail.com>
Subject: Re: [PATCH v2 10/26] x86, irq: Convert irq_2_pin list to generic list
From: Yinghai Lu <yinghai@kernel.org>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Sebastian Andrzej Siewior <sebastian@breakpoint.cc>,
        Joerg Roedel <joro@8bytes.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 8, 2013 at 11:50 AM, Konrad Rzeszutek Wilk
<konrad.wilk@oracle.com> wrote:
> On Fri, Feb 08, 2013 at 11:28:07AM -0800, Yinghai Lu wrote:
>> Now irq_2_pin list is own grown list.
>
> I think you meant to say 'has its own list'. Not sure how
> its growing?
>
>> We can use generic list to replace it so we could generic helper
>> functions to operate it.
>
> You need to put the verb a bit earlier. Perhaps:
>
> ".. generic list to replace so that we can operate using
> generic helper functions."

missed use before generic helper.

>
>>
>> Also make free_irq_cfg() free irq_2_pin list to support coming ioapic
>> hotplug.
>
> If you have them ready - could you say the titles of the patches here?

list them all ?
