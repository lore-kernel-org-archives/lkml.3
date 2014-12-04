Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932579AbaLDQj4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 11:39:56 -0500
Received: from mail.smart-weblications.de ([188.65.144.61]:51424 "EHLO
	mail.smart-weblications.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932197AbaLDQjx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 11:39:53 -0500
Message-ID: <54808E78.6070603@smart-weblications.de>
Date: Thu, 04 Dec 2014 17:40:24 +0100
From: Smart Weblications GmbH - Florian Wiessner 
	<f.wiessner@smart-weblications.de>
Reply-To: f.wiessner@smart-weblications.de
Organization: Smart Weblications GmbH
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Jiri Slaby <jslaby@suse.cz>, netdev@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org
Subject: Re: 3.12.33 - BUG xfrm_selector_match+0x25/0x2f6
References: <547F2462.6040405@smart-weblications.de> <54802D14.9030509@suse.cz>
In-Reply-To: <54802D14.9030509@suse.cz>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

Am 04.12.2014 10:44, schrieb Jiri Slaby:
> On 12/03/2014, 03:55 PM, Smart Weblications GmbH - Florian Wiessner wrote:

>> [16623.095403] BUG: unable to handle kernel paging request at 00000000010600d0
[...]
>> [16623.096721] Call Trace:
[...]

>> This happens again and again with 3.12.33
>>
>>
>> see also: http://www.spinics.net/lists/netdev/msg306283.html
>>
>> is this already fixed somehow?
> 
> Hi, I doubt so, as you are the first one letting me know. Could you
> check whether 3.12.30 works OK for you?
> 

I can try that, but it will take me some time as i currently try a kernel
without xfrm support to calm down my users.

Could you please look at my other mail first, before i downgrade the kernel?


-- 

Mit freundlichen Grüßen,

Florian Wiessner

Smart Weblications GmbH
Martinsberger Str. 1
D-95119 Naila

fon.: +49 9282 9638 200
fax.: +49 9282 9638 205
24/7: +49 900 144 000 00 - 0,99 EUR/Min*
http://www.smart-weblications.de

--
Sitz der Gesellschaft: Naila
Geschäftsführer: Florian Wiessner
HRB-Nr.: HRB 3840 Amtsgericht Hof
*aus dem dt. Festnetz, ggf. abweichende Preise aus dem Mobilfunknetz
