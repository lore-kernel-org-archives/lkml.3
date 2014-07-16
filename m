Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754089AbaGPWlD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 18:41:03 -0400
Received: from smtprelay05.ispgateway.de ([80.67.31.93]:51101 "EHLO
	smtprelay05.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750935AbaGPWlA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 18:41:00 -0400
X-Greylist: delayed 383 seconds by postgrey-1.27 at vger.kernel.org; Wed, 16 Jul 2014 18:40:59 EDT
References: <1398561815-22033-1-git-send-email-peter@piie.net> <1399139966-10625-1-git-send-email-peter@piie.net> <20140716222434.GC17472@pd.tnic>
Message-ID: <cone.1405550072.529732.1059.1000@galar>
X-Mailer: http://www.courier-mta.org/cone/
From: Peter Feuerer <peter@piie.net>
To: Borislav Petkov <bp@alien8.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andreas Mohr <andi@lisas.de>, Borislav Petkov <bp@suse.de>,
        Zhang Rui <rui.zhang@intel.com>, Javi Merino <javi.merino@arm.com>
Subject: Re: [PATCH v3 0/6] acerhdf/thermal: adding new models, appropriate
         governor and minor clean up
Date: Thu, 17 Jul 2014 00:34:32 +0200
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset="US-ASCII"
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
X-Df-Sender: NDA0MDk0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Boris,

nice to hear from you.


Borislav Petkov writes:

> Hi Peter,
> 
> On Sat, May 03, 2014 at 07:59:20PM +0200, Peter Feuerer wrote:
>> This patch series is intended to:
>> 
>>   * Introduce "manual mode" support (Patch 1 & 2), which is needed to control
>>     the fan of a few new models.
>> 
>>   * Add an appropriate thermal governor (Patch 3 & 4).  Manipulating and
>>     fiddling around with the step-wise governor has been a very fragile thing
>>     in the past and as it broke again, I used the opportunity to add a two
>>     point thermal governor which implements the actual fan handling required by
>>     acerhdf and puts from my point of view things straight.
>> 
>>   * Do some minor clean up like:
>>       - adding second trip point for critical temperature (Patch 5)
>>       - removing _t suffix from struct which isn't typedef and replace unsigned
>>         char by u8 (Patch 6)
> 
> so what's the state of those?
> 
> In the meantime I noticed the breakage here too, after updating the
> kernel on the aspire one - the fan remains on.
> 
> Do you have a latest version which is ready for testing or should I take
> those?

I'll send out new set of patches by Sunday latestly, but you could of course 
start testing with version3 of the patchset, as I just planned to do minor 
fixes anyhow.

-- 
kind regards,
--peter;
