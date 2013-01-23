Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755922Ab3AWMts (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 07:49:48 -0500
Received: from mail-la0-f44.google.com ([209.85.215.44]:47873 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755823Ab3AWMtr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 07:49:47 -0500
Message-ID: <50FFDC62.4030408@gmail.com>
Date: Wed, 23 Jan 2013 13:49:38 +0100
From: Matthias Brugger <matthias.bgg@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Hans-Christian Egtvedt <egtvedt@samfundet.no>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Cesar Eduardo Barros <cesarb@cesarb.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Haavard Skinnemoen <hskinnemoen@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MAINTAINERS: update avr32 web ressources
References: <1358874981-8655-1-git-send-email-matthias.bgg@gmail.com> <20130122201002.GA11758@samfundet.no>
In-Reply-To: <20130122201002.GA11758@samfundet.no>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/22/2013 09:10 PM, Hans-Christian Egtvedt wrote:
> Around Tue 22 Jan 2013 18:16:21 +0100 or thereabout, Matthias Brugger wrote:
>> Web ressource http://avr32linux.org is no longer
>> available. This patch deletes the corresponding line.
>>
>> Signed-off-by: Matthias Brugger <matthias.bgg@gmail.com>
>> ---
>>   MAINTAINERS | 1 -
>>   1 file changed, 1 deletion(-)
>>
>> diff --git a/MAINTAINERS b/MAINTAINERS
>> index 3105c48..e9c1746 100644
>> --- a/MAINTAINERS
>> +++ b/MAINTAINERS
>> @@ -1489,7 +1489,6 @@ AVR32 ARCHITECTURE
>>   M:	Haavard Skinnemoen <hskinnemoen@gmail.com>
>>   M:	Hans-Christian Egtvedt <egtvedt@samfundet.no>
>>   W:	http://www.atmel.com/products/AVR32/
>> -W:	http://avr32linux.org/
> Actually, it is available at http://mirror.egtvedt.no/avr32linux.org/ which
> will be up as long as I'm maintainer. The link above should reflect that
> though.
http://avr32linux.org/ actually redirects to a blog talking about "sink 
the bismarck".
Can you redirect the URL to your mirror or should I send a patch for the
MAINTAINERS file?

>
>>   W:	http://avrfreaks.net/
>>   S:	Maintained
>>   F:	arch/avr32/

