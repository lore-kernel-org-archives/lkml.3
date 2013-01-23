Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756142Ab3AWOYX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 09:24:23 -0500
Received: from cassarossa.samfundet.no ([129.241.93.19]:46055 "EHLO
	cassarossa.samfundet.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754334Ab3AWOYW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 09:24:22 -0500
Date: Wed, 23 Jan 2013 15:24:09 +0100
From: Hans-Christian Egtvedt <egtvedt@samfundet.no>
To: Matthias Brugger <matthias.bgg@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Cesar Eduardo Barros <cesarb@cesarb.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Haavard Skinnemoen <hskinnemoen@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MAINTAINERS: update avr32 web ressources
Message-ID: <20130123142409.GB30142@samfundet.no>
References: <1358874981-8655-1-git-send-email-matthias.bgg@gmail.com>
 <20130122201002.GA11758@samfundet.no>
 <50FFDC62.4030408@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50FFDC62.4030408@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Around Wed 23 Jan 2013 13:49:38 +0100 or thereabout, Matthias Brugger wrote:
> On 01/22/2013 09:10 PM, Hans-Christian Egtvedt wrote:
>>Around Tue 22 Jan 2013 18:16:21 +0100 or thereabout, Matthias Brugger wrote:
>>>Web ressource http://avr32linux.org is no longer
>>>available. This patch deletes the corresponding line.
>>>
>>>Signed-off-by: Matthias Brugger <matthias.bgg@gmail.com>
>>>---
>>>  MAINTAINERS | 1 -
>>>  1 file changed, 1 deletion(-)
>>>
>>>diff --git a/MAINTAINERS b/MAINTAINERS
>>>index 3105c48..e9c1746 100644
>>>--- a/MAINTAINERS
>>>+++ b/MAINTAINERS
>>>@@ -1489,7 +1489,6 @@ AVR32 ARCHITECTURE
>>>  M:	Haavard Skinnemoen <hskinnemoen@gmail.com>
>>>  M:	Hans-Christian Egtvedt <egtvedt@samfundet.no>
>>>  W:	http://www.atmel.com/products/AVR32/
>>>-W:	http://avr32linux.org/
>>Actually, it is available at http://mirror.egtvedt.no/avr32linux.org/ which
>>will be up as long as I'm maintainer. The link above should reflect that
>>though.
> http://avr32linux.org/ actually redirects to a blog talking about
> "sink the bismarck".
> Can you redirect the URL to your mirror or should I send a patch for the
> MAINTAINERS file?

The domain has been taken by somebody else, hence the mirror site.

-- 
mvh
Hans-Christian Egtvedt
