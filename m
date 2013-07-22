Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757220Ab3GVJvv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 05:51:51 -0400
Received: from hm1479-10.locaweb.com.br ([201.76.49.80]:39980 "EHLO
	hm1479-10.locaweb.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755896Ab3GVJvt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 05:51:49 -0400
X-Greylist: delayed 1895 seconds by postgrey-1.27 at vger.kernel.org; Mon, 22 Jul 2013 05:51:48 EDT
X-LocaWeb-COR: locaweb_2009_x-mail
Message-ID: <51ECF949.4000802@cesarb.eti.br>
Date: Mon, 22 Jul 2013 06:20:09 -0300
From: Cesar Eduardo Barros <cesarb@cesarb.eti.br>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Paul Walmsley <paul@pwsan.com>
CC: Joe Perches <joe@perches.com>, Andrew Morton <akpm@linux-foundation.org>,
        Rajendra Nayak <rnayak@ti.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org
Subject: Re: [PATCH 03/18] MAINTAINERS: OMAP POWERDOMAIN, update patterns
References: <cover.1374451988.git.joe@perches.com>  <8c1406e78f8536ff46ad9000b5634487243d5854.1374451988.git.joe@perches.com>  <alpine.DEB.2.02.1307220501390.4804@utopia.booyaka.com> <1374470152.2061.28.camel@joe-AO722> <alpine.DEB.2.02.1307220530140.4804@utopia.booyaka.com>
In-Reply-To: <alpine.DEB.2.02.1307220530140.4804@utopia.booyaka.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
x-locaweb-id: 5II90qkwcFl608adNSKU11Mhs1xf0MgAzPC-CIfMoteOMOLYZkorw41aZgtgCBGiz7JOWdNt-MIUbUFIqc5n_VfP5aYHWPJEum0HS-HjJOvP2Fgkz8Ex-xG1-io92IEw5k9j7CMIrQbHCYNxvkjAhINv59LIeUDK18RBqAz2syoRCPyqxUlRXZQ8gVN3gDJw--3Eu24UQs49yGjuyGnLlA==
x-locaweb-id2: NjM2NTczNjE3MjYyNDA2MzY1NzM2MTcyNjIyZTY1NzQ2OTJlNjI3Mg==
X-CMAE-Score: 0
X-CMAE-Analysis: v=2.0 cv=BcRvJMR2 c=1 sm=1 a=rzCuQlPI7EASjEAoQJd5EQ==:17
	a=eV-di8Q2jpsA:10 a=ldckd25n7EIA:10 a=IkcTkHD0fZMA:10 a=GsVLPjiIVQUA:10
	a=VwQbUJbxAAAA:8 a=D19gQVrFAAAA:8 a=BvddMxssdcUQofTqN_IA:9
	a=QEXdDO2ut3YA:10 a=rzCuQlPI7EASjEAoQJd5EQ==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 22-07-2013 02:32, Paul Walmsley escreveu:
> On Sun, 21 Jul 2013, Joe Perches wrote:
>
>> I certainly don't object at all if Andrew picks
>> up the patches you mentioned and drops these 2.
>>
>> Andrew, here are links to Cesar's original patches
>> https://patchwork.kernel.org/project/LKML/list/?submitter=3513
>> https://lkml.org/lkml/2013/3/2/185
>>
>> It seems a few are similar/duplicated to these 18.
>>
>> Cesar, maybe you should resend yours.  I thought
>> they were applied and forgot all about them.
>
> Another possibility, assuming that there are some fixes from your series
> that Cesar didn't have, would be for you to take his patches into the
> series that you're sending to Andrew, assuming that you agree with them.
> Then we'd benefit from the superset of fixes.

I don't care whose patches are applied or who gets the credit. They are 
just trivial changes to a text file. What matters is that the patterns 
are correct enough that get_maintainer.pl does the right thing.

-- 
Cesar Eduardo Barros
cesarb@cesarb.eti.br
