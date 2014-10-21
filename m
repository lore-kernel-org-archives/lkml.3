Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755140AbaJUKib (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 06:38:31 -0400
Received: from smtprelay02.ispgateway.de ([80.67.18.44]:46107 "EHLO
	smtprelay02.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754574AbaJUKia (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 06:38:30 -0400
X-Greylist: delayed 411 seconds by postgrey-1.27 at vger.kernel.org; Tue, 21 Oct 2014 06:38:30 EDT
References: <1398561815-22033-1-git-send-email-peter@piie.net> <1406043436-17068-1-git-send-email-peter@piie.net> <1406043436-17068-4-git-send-email-peter@piie.net> <cone.1406384086.541895.7413.1000@galar> <1406514389.14109.7.camel@rzhang1-toshiba>
Message-ID: <cone.1413887350.971616.2744.1000@mups>
X-Mailer: http://www.courier-mta.org/cone/
From: Peter Feuerer <peter@piie.net>
To: Zhang Rui <rui.zhang@intel.com>
Cc: linux-pm@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andreas Mohr <andi@lisas.de>, Borislav Petkov <bp@suse.de>,
        Javi Merino <javi.merino@arm.com>
Subject: Re: [PATCH v5 3/6] thermal: Added Bang-bang thermal governor
Date: Tue, 21 Oct 2014 12:29:10 +0200
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset="US-ASCII"
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
X-Df-Sender: NDA0MDk0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rui,

Zhang Rui writes:

> On Sat, 2014-07-26 at 16:14 +0200, Peter Feuerer wrote:
>> Hi Rui,
>> 
>> Peter Feuerer writes:
>> 
>> > The bang-bang thermal governor uses a hysteresis to switch abruptly on
>> > or off a cooling device.  It is intended to control fans, which can
>> > not be throttled but just switched on or off.
>> > Bang-bang cannot be set as default governor as it is intended for
>> > special devices only.  For those special devices the driver needs to
>> > explicitely request it.
>> > 
>> > Cc: Andrew Morton <akpm@linux-foundation.org>
>> > Cc: Zhang Rui <rui.zhang@intel.com>
>> 
>> Anything that prevents you from giving your acked-by?
>> 
> NO.
> 
> I'll queue them for 3.18.

Are all 6 patches in for 3.18 as you promissed?

kind regards,
--peter;
