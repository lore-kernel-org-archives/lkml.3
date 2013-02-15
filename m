Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935422Ab3BOG4l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 01:56:41 -0500
Received: from mail-ob0-f181.google.com ([209.85.214.181]:36013 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932833Ab3BOG4j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 01:56:39 -0500
MIME-Version: 1.0
X-Originating-IP: [109.186.30.39]
In-Reply-To: <20130214225557.GI11362@atomide.com>
References: <1360882071-4072668-1-git-send-email-arnd@arndb.de>
 <1360882071-4072668-8-git-send-email-arnd@arndb.de> <20130214225557.GI11362@atomide.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Fri, 15 Feb 2013 08:56:18 +0200
Message-ID: <CAK=WgbaPGOi+=zR0VNMZ+iJxd0NEzxXG86EBSsT+4u9tH=rCSg@mail.gmail.com>
Subject: Re: [PATCH 7/9] remoteproc: omap: depend on OMAP_MBOX_FWK
To: Tony Lindgren <tony@atomide.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
        linux-arm <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "arm@kernel.org" <arm@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 15, 2013 at 12:55 AM, Tony Lindgren <tony@atomide.com> wrote:
> * Arnd Bergmann <arnd@arndb.de> [130214 14:51]:
>> Patch a62a6e98 "ARM: OMAP2+: Disable code that currently does not work
>> with multiplaform" makes the OMAP_MBOX_FWK option depend on !MULTIPLATFORM,
>> which means we cannot simply select that symbol from OMAP_REMOTEPROC.
>>
>> Turning the 'select' into 'depends on' ensures that all dependencies
>> are correct until OMAP_MBOX_FWK loses its dependency.
>>
>> Without this patch, building allmodconfig results in:
>>
>> drivers/remoteproc/omap_remoteproc.c:31:26: fatal error: plat/mailbox.h: No such file or directory
>>
>> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
>
> Acked-by: Tony Lindgren <tony@atomide.com>

Acked-by: Ohad Ben-Cohen <ohad@wizery.com>

Feel free to take this via your tree - thanks.
