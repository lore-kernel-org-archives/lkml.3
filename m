Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754271Ab3FJXzl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 19:55:41 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:46779 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753437Ab3FJXzj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 19:55:39 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.02.1306102125410.22970@ionos>
References: <1370644273-10495-1-git-send-email-yinghai@kernel.org>
	<1370644273-10495-11-git-send-email-yinghai@kernel.org>
	<alpine.LFD.2.02.1306102125410.22970@ionos>
Date: Mon, 10 Jun 2013 16:55:38 -0700
X-Google-Sender-Auth: k4Z2WADZXA7GMHk0h7ERXaaNdG4
Message-ID: <CAE9FiQXVPUVWpUU+c5p__-bbgOrVk9+K-EPnCrCBRe2Q0Hi_mg@mail.gmail.com>
Subject: Re: [PATCH v3 10/27] genirq: Split __irq_reserve_irqs from irq_alloc_descs
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Bjorn Helgaas <bhelgaas@google.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Alexander Gordeev <agordeev@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 10, 2013 at 12:39 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> On Fri, 7 Jun 2013, Yinghai Lu wrote:
>>  /**
>> - * irq_alloc_descs - allocate and initialize a range of irq descriptors
>> - * @irq:     Allocate for specific irq number if irq >= 0
>> + * __irq_reserve_descs - reserve and initialize a range of irq descriptors
>
> Did you even bother to run docbook ?
>
> No you didn't. Otherwise you'd have noticed that documentation for
> __irq_reserve_descs is not the right thing for a function named
> __irq_reserve_irqs.

sorry, will them consistent.

Thanks

Yinghai
