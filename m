Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162752Ab3DEVOJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 17:14:09 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:41159 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162478Ab3DEVOF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 17:14:05 -0400
Message-ID: <515F3E96.4040307@free-electrons.com>
Date: Fri, 05 Apr 2013 23:13:58 +0200
From: Gregory CLEMENT <gregory.clement@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Lior Amsalem <alior@marvell.com>, Andrew Lunn <andrew@lunn.ch>,
        Ike Pan <ike.pan@canonical.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        David Marlin <dmarlin@redhat.com>,
        Yehuda Yitschak <yehuday@marvell.com>,
        Tawfik Bayouk <tawfik@marvell.com>,
        Dan Frazier <dann.frazier@canonical.com>,
        Eran Ben-Avi <benavi@marvell.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Leif Lindholm <leif.lindholm@arm.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Jason Cooper <jason@lakedaemon.net>, Nadav Haklai <nadavh@marvell.com>,
        Jon Masters <jcm@redhat.com>, devicetree-discuss@lists.ozlabs.org,
        Rob Herring <rob.herring@calxeda.com>,
        linux-arm-kernel@lists.infradead.org,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Chris Van Hoof <vanhoof@canonical.com>,
        Nicolas Pitre <nico@fluxnic.net>, linux-kernel@vger.kernel.org,
        Maen Suleiman <maen@marvell.com>, Shadi Ammouri <shadi@marvell.com>,
        Olof Johansson <olof@lixom.net>
Subject: Re: [PATCH v2 2/9] arm: mvebu: Align the internal registers virtual
 base to support LPAE
References: <1365193444-13441-1-git-send-email-gregory.clement@free-electrons.com> <1365193444-13441-3-git-send-email-gregory.clement@free-electrons.com> <201304052250.28641.arnd@arndb.de>
In-Reply-To: <201304052250.28641.arnd@arndb.de>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/05/2013 10:50 PM, Arnd Bergmann wrote:
> On Friday 05 April 2013, Gregory CLEMENT wrote:
>> From: Lior Amsalem <alior@marvell.com>
>>
>> In order to be able to support he LPAE, the internal registers virtual
>> base must be aligned to 2MB.
>>
>> Signed-off-by: Lior Amsalem <alior@marvell.com>
>> Signed-off-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
> 
> This is a surprising limitation. Can you extend the above text to go into more
> detail where that alignment requirement comes from?
> 

The explanation I had was that in LPAE section size is 2MB, in earlyprintk we map
the internal registers and it must be section aligned.

> 	Arnd
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
> 


-- 
Gregory Clement, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
