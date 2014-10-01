Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751639AbaJATte (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 15:49:34 -0400
Received: from top.free-electrons.com ([176.31.233.9]:37510 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750987AbaJATtd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 15:49:33 -0400
Message-ID: <542C5ACB.70001@free-electrons.com>
Date: Wed, 01 Oct 2014 21:49:31 +0200
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: trivial@kernel.org, akpm@linux-foundation.org, arend@broadcom.com,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org
Subject: Re: [PATCH] [RESEND][TRIVIAL] treewide: fix occurrences of "the the
 "
References: <1393998723-4475-1-git-send-email-michael.opdenacker@free-electrons.com>	 <1412157182-6852-1-git-send-email-michael.opdenacker@free-electrons.com> <1412170370.3247.2.camel@joe-AO725>
In-Reply-To: <1412170370.3247.2.camel@joe-AO725>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joe,

Thank you very much for your review!

On 10/01/2014 03:32 PM, Joe Perches wrote:
> On Wed, 2014-10-01 at 11:53 +0200, Michael Opdenacker wrote:
>> Fix all occurrences of "the the " in the source code,
>> comments and documentation.
> []
>>  drivers/staging/rtl8187se/ieee80211/ieee80211_rx.c | 1486 ++++++++++++++++++++
> That one snuck in here where it doesn't belong.

Oops, right. I will review the line stats before submitting next time...
>
> Please fix and resubmit?

Sure, the update is on its way!

Thanks again,

Cheers,

Michael.

-- 
Michael Opdenacker, CEO, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
+33 484 258 098

