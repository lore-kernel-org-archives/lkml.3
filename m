Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934574Ab3E2BC3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 21:02:29 -0400
Received: from mx02.smart-weblications.de ([188.65.144.37]:45208 "EHLO
	mx02.smart-weblications.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934257Ab3E2BCZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 21:02:25 -0400
Message-ID: <51A55381.9080807@smart-weblications.de>
Date: Wed, 29 May 2013 03:01:53 +0200
From: Smart Weblications GmbH - Florian Wiessner 
	<f.wiessner@smart-weblications.de>
Reply-To: f.wiessner@smart-weblications.de
Organization: Smart Weblications GmbH
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: "Matthew O'Connor" <matt@ecsorl.com>
CC: Greg KH <gregkh@linuxfoundation.org>, davem@davemloft.net,
        andy@greyhouse.net, fubar@us.ibm.com,
        LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org,
        nikolay@redhat.com, vfalico@redhat.com, zheng.x.li@oracle.com,
        liquidhorse@gmail.com
Subject: Re: https://lkml.org/lkml/2013/2/1/531
References: <519CADA9.9060909@smart-weblications.de> <20130522135745.GA14640@kroah.com> <519CEF4B.5090108@smart-weblications.de> <20130522162336.GA5761@kroah.com> <519D0B79.6010307@smart-weblications.de> <20130522190640.GA20276@kroah.com> <519D1DEF.8090206@smart-weblications.de> <20130522200439.GA21367@kroah.com> <519D37F4.2030202@smart-weblications.de> <519D5206.8080701@gmail.com> <519DEE6E.7060700@smart-weblications.de> <519E0F97.1050102@ecsorl.com>
In-Reply-To: <519E0F97.1050102@ecsorl.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 23.05.2013 14:46, schrieb Matthew O'Connor:
> On 05/23/2013 06:24 AM, Smart Weblications GmbH - Florian Wiessner wrote:
>> node02:/ocfs2/usr/src/linux-3.4.46# cat drivers/net/bonding/bond_alb.c.rej
> My most sincere apologies - one more time, from a different mail server
> that hopefully won't go around changing my attachments.  If this doesn't
> work I guess sendmail will be the next alternative.
> 

3.4.47 got released without that included :-/?!

https://www.kernel.org/pub/linux/kernel/v3.x/ChangeLog-3.4.47


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
