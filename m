Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754721Ab3EVSRg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 14:17:36 -0400
Received: from mx04.smart-weblications.de ([188.65.144.39]:58764 "EHLO
	mx04.smart-weblications.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752606Ab3EVSRf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 14:17:35 -0400
Message-ID: <519D0B79.6010307@smart-weblications.de>
Date: Wed, 22 May 2013 20:16:25 +0200
From: Smart Weblications GmbH - Florian Wiessner 
	<f.wiessner@smart-weblications.de>
Reply-To: f.wiessner@smart-weblications.de
Organization: Smart Weblications GmbH
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: davem@davemloft.net, liquidhorse@gmail.com, andy@greyhouse.net,
        fubar@us.ibm.com, LKML <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org, nikolay@redhat.com, vfalico@redhat.com
Subject: Re: https://lkml.org/lkml/2013/2/1/531
References: <519CADA9.9060909@smart-weblications.de> <20130522135745.GA14640@kroah.com> <519CEF4B.5090108@smart-weblications.de> <20130522162336.GA5761@kroah.com>
In-Reply-To: <20130522162336.GA5761@kroah.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


Am 22.05.2013 18:23, schrieb Greg KH:
> On Wed, May 22, 2013 at 06:16:11PM +0200, Smart Weblications GmbH - Florian Wiessner wrote:
>> Am 22.05.2013 15:57, schrieb Greg KH:
>>> On Wed, May 22, 2013 at 01:36:09PM +0200, Smart Weblications GmbH - Florian Wiessner wrote:
>>>> Hi,
>>>>
>>>> why is this patch still not backported to 3.4?
>>>>
>>>> I today tried 3.4.46 from kernel.org, but the patch STILL seems _NOT_ included?
>>>>
>>>> WHY IS THAT?
>>>
>>> <formletter>
>>>
>>> This is not the correct way to submit patches for inclusion in the
>>> stable kernel tree.  Please read Documentation/stable_kernel_rules.txt
>>> for how to do this properly.
>>>
>>> </formletter>
>>>
>>
>>
>> I don't want to submit a patch - i wanted to know why this patch still is not in
>> the kernel (it is afaics at least 6 months old!)
> 
> Perhaps because it was not submitted properly as documented above?
> 

Well, i don't know. I have not written that patch, but tested and applied it
against 3.4.36 where it worked fine.

But i am unable to apply it to 3.4.46 (there are rejects if i try to apply it,
obviously because there were changes in the meanwhile) - It would be cool if
someone could tell if that patch is really needed anymore with 3.4.46.

I am no C coder and only have little C experience, but i'd like to use this
patch with current 3.4 stable Kernel or at least make sure that this patch is
not needed anymore with current stable kernels...

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
