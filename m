Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753509Ab3DLLFV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 07:05:21 -0400
Received: from smtp-out-217.synserver.de ([212.40.185.217]:1046 "EHLO
	smtp-out-217.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753304Ab3DLLFS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 07:05:18 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 3897
Message-ID: <5167EA36.5080505@metafoo.de>
Date: Fri, 12 Apr 2013 13:04:22 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130116 Icedove/10.0.12
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Arnd Bergmann <arnd@arndb.de>, alsa-devel@alsa-project.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Liam Girdwood <lgirdwood@gmail.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [alsa-devel] [PATCH 18/30] ASoC: samsung: move plat/ headers
 to local directory
References: <1365638712-1028578-1-git-send-email-arnd@arndb.de> <1365638712-1028578-19-git-send-email-arnd@arndb.de> <20130411164751.GK9243@opensource.wolfsonmicro.com> <201304111908.42532.arnd@arndb.de> <20130411171938.GS9243@opensource.wolfsonmicro.com>
In-Reply-To: <20130411171938.GS9243@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/11/2013 07:19 PM, Mark Brown wrote:
> On Thu, Apr 11, 2013 at 07:08:42PM +0200, Arnd Bergmann wrote:
>> On Thursday 11 April 2013, Mark Brown wrote:
> 
>>> This doesn't apply to my topic/samsung branch, can you please regenerate
>>> it against that or let me know what to apply it against?
> 
>> This one should work. Unfortunately I now found during testing that the
>> s3c24xx sound support has a few build errors at the moment, but this
>> patch should not add any new ones:
> 
> Applied (after hand editing the commit message), thanks.
> 
>> make[5]: *** [sound/soc/samsung/i2s.o] Error 1
>> /git/arm-soc/sound/soc/samsung/neo1973_wm8753.c:25:24: fatal error: mach/gta02.h: No such file or directory
>>  #include <mach/gta02.h>
> 
> Hrm, someone killed GTA02 support?  That's sad...  if that's really the
> case we could kill the machine driver but not tonight as I'm running
> late...

I think the file was moved, we should pull over the audio relevant GPIO
definitions into the ASoC board driver.

- Lars
