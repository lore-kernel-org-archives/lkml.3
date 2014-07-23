Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932172AbaGWPIy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 11:08:54 -0400
Received: from mail-vc0-f179.google.com ([209.85.220.179]:51266 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756908AbaGWPIx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 11:08:53 -0400
MIME-Version: 1.0
In-Reply-To: <20140723074328.GI18374@atomide.com>
References: <CAPDOMVinWFVKY=mMOA1f6pd4orOgcKh1kE01MPVaLZi0Z_tMmg@mail.gmail.com>
	<20140723074328.GI18374@atomide.com>
Date: Wed, 23 Jul 2014 11:08:51 -0400
Message-ID: <CAPDOMVjrSskMHq0ZdB6mpGJBn9gvbpguLSK-+aHaV9k0QrqzHA@mail.gmail.com>
Subject: Re: omap-wakeupgen.c: Remove function for fix me
From: Nick Krause <xerofoify@gmail.com>
To: Tony Lindgren <tony@atomide.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 23, 2014 at 3:43 AM, Tony Lindgren <tony@atomide.com> wrote:
> * Nick Krause <xerofoify@gmail.com> [140722 14:12]:
>> static void __init irq_pm_init(void)
>> 382 {
>> 383         /* FIXME: Remove this when MPU OSWR support is added */
>> 384         if (!soc_is_omap54xx())
>> 385                 cpu_pm_register_notifier(&irq_notifier_block);
>> 386 }
>> I am wondering is this omap supported now if it is can I remove it?
>
> Does REVISIT cause issues for you with cscope? It may be easier to
> replace the cscope bugging FIXME statements with just REVISIT unless
> a real fix is provided.
>
> Regards,
>
> Tony


Very well then , seems like a good idea will try later.
Nick
