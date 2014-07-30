Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755159AbaG3HGg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 03:06:36 -0400
Received: from aer-iport-3.cisco.com ([173.38.203.53]:64000 "EHLO
	aer-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754653AbaG3HGe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 03:06:34 -0400
X-Greylist: delayed 302 seconds by postgrey-1.27 at vger.kernel.org; Wed, 30 Jul 2014 03:06:33 EDT
X-IronPort-AV: E=Sophos;i="5.01,762,1400025600"; 
   d="scan'208";a="122350942"
Message-ID: <53D898B5.4010300@cisco.com>
Date: Wed, 30 Jul 2014 09:03:17 +0200
From: Hans Verkuil <hansverk@cisco.com>
Organization: Cisco Systems Norway
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.0
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>, Andrew Morton <akpm@linux-foundation.org>
CC: Ismael Luceno <ismael.luceno@corp.bluecherry.net>,
        Hans Verkuil <hans.verkuil@cisco.com>, linux-kernel@vger.kernel.org,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 4/6] MAINTAINERS: Update solo6x10 patterns
References: <cover.1406691397.git.joe@perches.com> <7142cc450c37b75474780f2e4610d5a44a0f757b.1406691397.git.joe@perches.com> <53D8987F.1020304@cisco.com>
In-Reply-To: <53D8987F.1020304@cisco.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Authenticated-User: hansverk
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Repost, this time with the linux-media ml included.

On 07/30/2014 09:02 AM, Hans Verkuil wrote:
> On 07/30/2014 05:38 AM, Joe Perches wrote:
>> commit 28cae868cd24 ("[media] solo6x10: move out of staging into
>> drivers/media/pci") moved the files, update the patterns.
>>
>> Signed-off-by: Joe Perches <joe@perches.com>
>> cc: Ismael Luceno <ismael.luceno@corp.bluecherry.net>
>> cc: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Acked-By: Hans Verkuil <hans.verkuil@cisco.com>
> 
> I'll pull this one in through our linux-media repo.
> 
> Thanks,
> 
> 	Hans
> 
>> ---
>>  MAINTAINERS | 11 ++++++-----
>>  1 file changed, 6 insertions(+), 5 deletions(-)
>>
>> diff --git a/MAINTAINERS b/MAINTAINERS
>> index 3960ba8..8ed337c 100644
>> --- a/MAINTAINERS
>> +++ b/MAINTAINERS
>> @@ -8403,6 +8403,12 @@ M:	Chris Boot <bootc@bootc.net>
>>  S:	Maintained
>>  F:	drivers/leds/leds-net48xx.c
>>  
>> +SOFTLOGIC 6x10 MPEG CODEC
>> +M:	Ismael Luceno <ismael.luceno@corp.bluecherry.net>
>> +L:	linux-media@vger.kernel.org
>> +S:	Supported
>> +F:	drivers/media/pci/solo6x10/
>> +
>>  SOFTWARE RAID (Multiple Disks) SUPPORT
>>  M:	Neil Brown <neilb@suse.de>
>>  L:	linux-raid@vger.kernel.org
>> @@ -8666,11 +8672,6 @@ M:	Christopher Harrer <charrer@alacritech.com>
>>  S:	Odd Fixes
>>  F:	drivers/staging/slicoss/
>>  
>> -STAGING - SOFTLOGIC 6x10 MPEG CODEC
>> -M:	Ismael Luceno <ismael.luceno@corp.bluecherry.net>
>> -S:	Supported
>> -F:	drivers/staging/media/solo6x10/
>> -
>>  STAGING - SPEAKUP CONSOLE SPEECH DRIVER
>>  M:	William Hubbs <w.d.hubbs@gmail.com>
>>  M:	Chris Brannon <chris@the-brannons.com>
>>
> 

