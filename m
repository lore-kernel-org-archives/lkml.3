Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759143Ab3EWNgs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 09:36:48 -0400
Received: from mx03.smart-weblications.de ([188.65.144.38]:44141 "EHLO
	mx03.smart-weblications.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759022Ab3EWNgq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 09:36:46 -0400
Message-ID: <519E1B63.2090309@smart-weblications.de>
Date: Thu, 23 May 2013 15:36:35 +0200
From: Smart Weblications GmbH - Florian Wiessner 
	<f.wiessner@smart-weblications.de>
Reply-To: f.wiessner@smart-weblications.de
Organization: Smart Weblications GmbH
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: "Matthew O'Connor" <liquidhorse@gmail.com>
CC: Greg KH <gregkh@linuxfoundation.org>, davem@davemloft.net,
        andy@greyhouse.net, fubar@us.ibm.com,
        LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org,
        nikolay@redhat.com, vfalico@redhat.com, zheng.x.li@oracle.com
Subject: Re: https://lkml.org/lkml/2013/2/1/531
References: <519CADA9.9060909@smart-weblications.de> <20130522135745.GA14640@kroah.com> <519CEF4B.5090108@smart-weblications.de> <20130522162336.GA5761@kroah.com> <519D0B79.6010307@smart-weblications.de> <20130522190640.GA20276@kroah.com> <519D1DEF.8090206@smart-weblications.de> <20130522200439.GA21367@kroah.com> <519D37F4.2030202@smart-weblications.de> <519D5206.8080701@gmail.com> <519DEE6E.7060700@smart-weblications.de> <519E0CF5.7000308@gmail.com>
In-Reply-To: <519E0CF5.7000308@gmail.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 23.05.2013 14:35, schrieb Matthew O'Connor:
> On 05/23/2013 06:24 AM, Smart Weblications GmbH - Florian Wiessner wrote:
>> Hm, i tried to apply it to 3.4.46 but it does not work:
>>
>> node02:/ocfs2/usr/src/linux-3.4.46# patch -p1 <../bridge-patch-3.4.46
>> patching file drivers/net/bonding/bond_alb.c
>> Hunk #1 FAILED at 704.
>> 1 out of 1 hunk FAILED -- saving rejects to file drivers/net/bonding/bond_alb.c.rej
>> patching file drivers/net/bonding/bonding.h
>> patching file include/linux/etherdevice.h
>> Hunk #1 FAILED at 277.
>> 1 out of 1 hunk FAILED -- saving rejects to file include/linux/etherdevice.h.rej
> That is extremely odd, considering I applied this to a freshly
> downloaded kernel source directly from kernel.org before resubmitting it:
> 
> hv11:~/kernel/linux-3.4.46$ patch -p1 <
> ../balance-alb-patches/balance-alb-3.4.patch
> patching file drivers/net/bonding/bond_alb.c
> patching file drivers/net/bonding/bonding.h
> patching file include/linux/etherdevice.h
> 
> 
> Here's the patch as an attachment instead; I suspect it keeps getting
> damaged by my method of inclusion.


Thank you, this now worked for me!


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
