Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757195Ab3FCL4F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 07:56:05 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:35680 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753958Ab3FCL4D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 07:56:03 -0400
Message-ID: <51AC844C.1050500@linaro.org>
Date: Mon, 03 Jun 2013 17:25:56 +0530
From: Tushar Behera <tushar.behera@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Tomasz Figa <t.figa@samsung.com>
CC: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, arnd@arndb.de,
        kgene.kim@samsung.com, olof@lixom.net, patches@linaro.org
Subject: Re: [PATCH 3/3] ARM: S5P64X0: Remove duplicate uncompress code
References: <1370000944-19786-1-git-send-email-tushar.behera@linaro.org> <51A9B3BC.9000405@gmail.com> <51AC18FF.9010108@linaro.org> <13570629.4jzYey0dyq@amdc1227>
In-Reply-To: <13570629.4jzYey0dyq@amdc1227>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>
>> Tomasz,
>>
>> I had somehow missed that mail.
>>
>> The patch that I have additionally makes calculation of uart_base
>> conditional on DEBUG_LL in line with the rest of the patches.
>>
>> Would you mind re-spining your patch with those changes?
>>
>> Alternately, I can take your patch and do above modifications in them.
> 
> Unfortunately I'm unlikely to find time to do it myself in nearest future, so 
> feel free to do it. Thanks.
> 
> Keep in mind, however, that this patch was a dependency of
> 
> [PATCH 0/6] Samsung watchdog support clean-up
> http://thread.gmane.org/gmane.linux.kernel.samsung-soc/18736/focus=18951
> 
> so I would like to keep this series applicable.
> 

Sure. I will ensure that there is minimal change to the original patch
that you submitted.

> Best regards,
> 


-- 
Tushar Behera
