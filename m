Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935144Ab3DKUlt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 16:41:49 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:36768 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935101Ab3DKUlo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 16:41:44 -0400
Message-ID: <51671FFE.1010909@free-electrons.com>
Date: Thu, 11 Apr 2013 22:41:34 +0200
From: Gregory CLEMENT <gregory.clement@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Jason Cooper <jason@lakedaemon.net>
CC: Andrew Lunn <andrew@lunn.ch>, Lior Amsalem <alior@marvell.com>,
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
        Arnd Bergmann <arnd@arndb.de>, Jon Masters <jcm@redhat.com>,
        devicetree-discuss@lists.ozlabs.org,
        Rob Herring <rob.herring@calxeda.com>,
        linux-arm-kernel@lists.infradead.org,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Chris Van Hoof <vanhoof@canonical.com>,
        Nicolas Pitre <nico@fluxnic.net>, linux-kernel@vger.kernel.org,
        Maen Suleiman <maen@marvell.com>, Nadav Haklai <nadavh@marvell.com>,
        Shadi Ammouri <shadi@marvell.com>, Olof Johansson <olof@lixom.net>
Subject: Re: [PATCH v3 4/9] ARM: mvebu: Enable pj4b on LPAE compilations
References: <1365461538-30702-1-git-send-email-gregory.clement@free-electrons.com> <1365461538-30702-5-git-send-email-gregory.clement@free-electrons.com> <20130411180844.GO28693@titan.lakedaemon.net>
In-Reply-To: <20130411180844.GO28693@titan.lakedaemon.net>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jason,

On 04/11/2013 08:08 PM, Jason Cooper wrote:
> On Tue, Apr 09, 2013 at 12:52:12AM +0200, Gregory CLEMENT wrote:
>> From: Lior Amsalem <alior@marvell.com>
>>
>> pj4b cpus are LPAE capable so enable them on LPAE compilations
>>
>> Signed-off-by: Lior Amsalem <alior@marvell.com>
>> Tested-by: Franklin <flin@marvell.com>
>> Signed-off-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
>> ---
>>  arch/arm/mm/proc-v7.S |    3 ++-
>>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> Applied to mvebu/soc
> 
> thx,
> 
> Jason.
> 

First thanks for pulling all these patches.

However, this one should go through Russell's git tree.  Or at least
you need his acked-by. I have already submit this patch on Russell
patch system. Unfortunately Russell told that he will be away for
around one week.

This patch is needed to have LPAE support, but all the other patches
don't depend on it. That means that if you applied all the other
patches it won't break anything even if at the end this patch is not
merged. But I really hope that Russell will be able to apply this
patch to his git tree.

Thanks

-- 
Gregory Clement, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
