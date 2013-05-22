Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757301Ab3EVV02 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 17:26:28 -0400
Received: from mx04.smart-weblications.de ([188.65.144.39]:36807 "EHLO
	mx04.smart-weblications.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753218Ab3EVV00 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 17:26:26 -0400
Message-ID: <519D37F4.2030202@smart-weblications.de>
Date: Wed, 22 May 2013 23:26:12 +0200
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
References: <519CADA9.9060909@smart-weblications.de> <20130522135745.GA14640@kroah.com> <519CEF4B.5090108@smart-weblications.de> <20130522162336.GA5761@kroah.com> <519D0B79.6010307@smart-weblications.de> <20130522190640.GA20276@kroah.com> <519D1DEF.8090206@smart-weblications.de> <20130522200439.GA21367@kroah.com>
In-Reply-To: <20130522200439.GA21367@kroah.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,


Am 22.05.2013 22:04, schrieb Greg KH:


>>
>> https://kernel.googlesource.com/pub/scm/linux/kernel/git/jkirsher/net-next/+/567b871e503316b0927e54a3d7c86d50b722d955%5E!/
> 
> Ok, that's what we need.
> 
> Now, please cc: the developers / maintainers of that patch and ask them
> to have it included in the 3.4-stable kernel series.
> 
> Then, if they agree, the network maintainer will pick it up and send it
> to me for inclusion.
> 

i set committer	David S. Miller <davem@davemloft.net> in cc already, but do not
know the network maintainer...

this seems to me that "Matthew O'Connor" <liquidhorse@gmail.com> sent this to
netdev on 2013-02-01:

http://lists.openwall.net/netdev/2013/02/01/86

but i couldn't find a trace of the patch in 3.4.36?!

Instead, i read another try to get it backported fail:

http://permalink.gmane.org/gmane.linux.network/264198






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
