Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932759Ab3FRLrx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 07:47:53 -0400
Received: from mx03.smart-weblications.de ([188.65.144.38]:57351 "EHLO
	mx03.smart-weblications.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932370Ab3FRLrm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 07:47:42 -0400
Message-ID: <51C048E6.6010602@smart-weblications.de>
Date: Tue, 18 Jun 2013 13:47:50 +0200
From: Smart Weblications GmbH - Florian Wiessner 
	<f.wiessner@smart-weblications.de>
Reply-To: f.wiessner@smart-weblications.de
Organization: Smart Weblications GmbH
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Ben Hutchings <ben@decadent.org.uk>
CC: "Matthew O'Connor" <liquidhorse@gmail.com>,
        Greg KH <gregkh@linuxfoundation.org>, davem@davemloft.net,
        andy@greyhouse.net, fubar@us.ibm.com,
        LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org,
        nikolay@redhat.com, vfalico@redhat.com, zheng.x.li@oracle.com
Subject: Re: https://lkml.org/lkml/2013/2/1/531
References: <519CADA9.9060909@smart-weblications.de>  <20130522135745.GA14640@kroah.com> <519CEF4B.5090108@smart-weblications.de>  <20130522162336.GA5761@kroah.com> <519D0B79.6010307@smart-weblications.de>  <20130522190640.GA20276@kroah.com> <519D1DEF.8090206@smart-weblications.de>  <20130522200439.GA21367@kroah.com> <519D37F4.2030202@smart-weblications.de>  <519D5206.8080701@gmail.com> <1371086125.10688.5.camel@deadeye.wl.decadent.org.uk>
In-Reply-To: <1371086125.10688.5.camel@deadeye.wl.decadent.org.uk>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 13.06.2013 03:15, schrieb Ben Hutchings:
> On Wed, 2013-05-22 at 19:17 -0400, Matthew O'Connor wrote:
>> This is the backported patch I submitted previously.  Hopefully this time
>> around it won't be too messed up, I'm using Thunderbird instead of the
>> web interface.
> [...]
> 
> This was whitespace-damaged; please read Documentation/email-clients.txt
> 
> Also put the description in the subject line, like this:
> 
> Subject: [PATCH 3.4.y] bonding: rlb mode of bond should not alter ARP
> originating via bridge
> 
> Ben.
> 


Now we have 3.4.49, still this patch is not included? WHY?

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
