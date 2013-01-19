Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752024Ab3ASM2w (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2013 07:28:52 -0500
Received: from us02smtp2.synopsys.com ([198.182.60.77]:52203 "EHLO
	alvesta.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751414Ab3ASM2v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2013 07:28:51 -0500
Message-ID: <50FA9109.9070106@synopsys.com>
Date: Sat, 19 Jan 2013 17:56:49 +0530
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <arnd@arndb.de>
Subject: Re: [PATCH v2 31/76] ARC: Build system: Makefiles, Kconfig, Linker
 script
References: <1358511930-7424-1-git-send-email-vgupta@synopsys.com> <1358511930-7424-32-git-send-email-vgupta@synopsys.com> <20130118190811.GA14441@merkur.ravnborg.org>
In-Reply-To: <20130118190811.GA14441@merkur.ravnborg.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.12.197.205]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 19 January 2013 12:38 AM, Sam Ravnborg wrote:
>>  arch/arc/include/asm/vmlinux.lds.h |   12 ++
> I see no reason for this file?
>
>> .....
>> +#ifndef __ASM_VMLINUX_LDS_H__
>> +#define __ASM_VMLINUX_LDS_H__
>> +
>> +#endif
> It is empty.
> Only sh provide one today (which is not empty).
>
> 	Sam

There used to be some code in this file (some section annotations needed in linker
script), but that was moved out to linkage.h. Anyhow, as you rightly observe, we
don't need this anymore - hence nuked.

Thx,
-Vineet
