Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752148AbaJ1Tdq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 15:33:46 -0400
Received: from smtprelay06.ispgateway.de ([80.67.18.29]:35973 "EHLO
	smtprelay06.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750857AbaJ1Tdp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 15:33:45 -0400
References: <1398561815-22033-1-git-send-email-peter@piie.net> <1406043436-17068-1-git-send-email-peter@piie.net> <1406043436-17068-4-git-send-email-peter@piie.net> <cone.1406384086.541895.7413.1000@galar> <1406514389.14109.7.camel@rzhang1-toshiba> <cone.1413887350.971616.2744.1000@mups>
Message-ID: <cone.1414524819.964570.994.1000@galar>
X-Mailer: http://www.courier-mta.org/cone/
From: Peter Feuerer <peter@piie.net>
To: Peter Feuerer <peter@piie.net>
Cc: Zhang Rui <rui.zhang@intel.com>, linux-pm@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andreas Mohr <andi@lisas.de>, Borislav Petkov <bp@suse.de>,
        Javi Merino <javi.merino@arm.com>
Subject: Re: [PATCH v5 3/6] thermal: Added Bang-bang thermal governor
Date: Tue, 28 Oct 2014 20:33:39 +0100
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset="US-ASCII"
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
X-Df-Sender: NDA0MDk0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rui,

I wonder whether you've had time to apply my set of patches already?  Would 
you please be so kind to just send me a short reply?

thanks and kind regards,
--peter;


Peter Feuerer writes:

> Hi Rui,
> 
> Zhang Rui writes:
> 
>> On Sat, 2014-07-26 at 16:14 +0200, Peter Feuerer wrote:
>>> Hi Rui,
>>> 
>>> Peter Feuerer writes:
>>> 
>>> > The bang-bang thermal governor uses a hysteresis to switch abruptly on
>>> > or off a cooling device.  It is intended to control fans, which can
>>> > not be throttled but just switched on or off.
>>> > Bang-bang cannot be set as default governor as it is intended for
>>> > special devices only.  For those special devices the driver needs to
>>> > explicitely request it.
>>> > 
>>> > Cc: Andrew Morton <akpm@linux-foundation.org>
>>> > Cc: Zhang Rui <rui.zhang@intel.com>
>>> 
>>> Anything that prevents you from giving your acked-by?
>>> 
>> NO.
>> 
>> I'll queue them for 3.18.
> 
> Are all 6 patches in for 3.18 as you promissed?
> 
> kind regards,
> --peter;
