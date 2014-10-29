Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932316AbaJ2KVV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 06:21:21 -0400
Received: from smtprelay05.ispgateway.de ([80.67.31.99]:43269 "EHLO
	smtprelay05.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932072AbaJ2KVT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 06:21:19 -0400
X-Greylist: delayed 360 seconds by postgrey-1.27 at vger.kernel.org; Wed, 29 Oct 2014 06:21:18 EDT
References: <1398561815-22033-1-git-send-email-peter@piie.net> <1406043436-17068-1-git-send-email-peter@piie.net> <1406043436-17068-4-git-send-email-peter@piie.net> <cone.1406384086.541895.7413.1000@galar> <1406514389.14109.7.camel@rzhang1-toshiba> <cone.1413887350.971616.2744.1000@mups> <cone.1414524819.964570.994.1000@galar> <20141029094407.GA2692@e104805>
Message-ID: <cone.1414577692.495190.15782.1000@mups>
X-Mailer: http://www.courier-mta.org/cone/
From: Peter Feuerer <peter@piie.net>
To: Javi Merino <javi.merino@arm.com>
Cc: Zhang Rui <rui.zhang@intel.com>,
        =?UTF-8?B?bGludXgtcG1Admdlci5rZXJuZWwub3Jn?= 
	<linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v5 3/6] thermal: Added Bang-bang thermal governor
Date: Wed, 29 Oct 2014 11:14:52 +0100
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset="US-ASCII"
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
X-Df-Sender: NDA0MDk0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Javi,

Javi Merino writes:

> On Tue, Oct 28, 2014 at 07:33:39PM +0000, Peter Feuerer wrote:
>> Hi Rui,
>> 
>> I wonder whether you've had time to apply my set of patches already?  Would 
>> you please be so kind to just send me a short reply?
> 
> The bang-bang governor was merged and is part of v3.18-rc2:
> 
> https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=8264fce6de03f3915e2301f52f181a982718a8cb

Thanks for your mail.

Seems like the other 5 patches of the series were not applied.  So I 
need to take care again, or?

kind regards,
--peter;


> 
> Cheers,
> Javi
> 
>> Peter Feuerer writes:
>> 
>> > Hi Rui,
>> > 
>> > Zhang Rui writes:
>> > 
>> >> On Sat, 2014-07-26 at 16:14 +0200, Peter Feuerer wrote:
>> >>> Hi Rui,
>> >>> 
>> >>> Peter Feuerer writes:
>> >>> 
>> >>> > The bang-bang thermal governor uses a hysteresis to switch abruptly on
>> >>> > or off a cooling device.  It is intended to control fans, which can
>> >>> > not be throttled but just switched on or off.
>> >>> > Bang-bang cannot be set as default governor as it is intended for
>> >>> > special devices only.  For those special devices the driver needs to
>> >>> > explicitely request it.
>> >>> > 
>> >>> > Cc: Andrew Morton <akpm@linux-foundation.org>
>> >>> > Cc: Zhang Rui <rui.zhang@intel.com>
>> >>> 
>> >>> Anything that prevents you from giving your acked-by?
>> >>> 
>> >> NO.
>> >> 
>> >> I'll queue them for 3.18.
>> > 
>> > Are all 6 patches in for 3.18 as you promissed?
>> > 
>> > kind regards,
>> > --peter;
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>> 
> 
