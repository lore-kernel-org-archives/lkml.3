Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759966AbaGYLBO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 07:01:14 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:38004 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758404AbaGYLBM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 07:01:12 -0400
Message-ID: <53D238E1.3030901@gmail.com>
Date: Fri, 25 Jul 2014 13:00:49 +0200
From: Tomasz Figa <tomasz.figa@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Pankaj Dubey <pankaj.dubey@samsung.com>,
        "'Kukjin Kim'" <kgene.kim@samsung.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
CC: linux@arm.linux.org.uk, t.figa@samsung.com, vikas.sajjan@samsung.com,
        joshi@samsung.com, naushad@samsung.com, thomas.ab@samsung.com,
        chow.kim@samsung.com
Subject: Re: [PATCH v7 3/4] ARM: EXYNOS: Add platform driver support for Exynos
 PMU
References: <1404878455-31518-1-git-send-email-pankaj.dubey@samsung.com> <1404878455-31518-4-git-send-email-pankaj.dubey@samsung.com> <067501cfa7bd$8e6cb460$ab461d20$@samsung.com> <000501cfa7c9$e59f4840$b0ddd8c0$@samsung.com>
In-Reply-To: <000501cfa7c9$e59f4840$b0ddd8c0$@samsung.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pankaj, Kukjin,

On 25.07.2014 07:32, Pankaj Dubey wrote:
> Hi Kukjin,
> 
> On Friday, July 25, 2014 Kukjin Kim wrote:

[snip]

>>>
>> Looks good to me, will apply this and 4/4.
>>
> 
> We need to hold these two patches until dependent patch [1] from Tomasz Figa
> gets merged.
> 
> [1]: mfd: syscon: Decouple syscon interface from syscon devices
>       https://lkml.org/lkml/2014/6/24/188

That RFC patch had few comments from Arnd needed to be addressed, so it
needs a new revision.

Pankaj, If I remember correctly, we had talked about this and the
conclusion was that you would take care of addressing the comments and
sending new version of the patch. Any update on this or have I missed
something?

Best regards,
Tomasz
