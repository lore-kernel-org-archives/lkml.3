Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752728AbaEGVtD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 17:49:03 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:55606 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752300AbaEGVs6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 17:48:58 -0400
Message-ID: <536AAA31.6080905@ti.com>
Date: Wed, 7 May 2014 16:48:33 -0500
From: Joel Fernandes <joelf@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Tony Lindgren <tony@atomide.com>
CC: Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 02/26] ARM: OMAP: dmtimer: Add comments on OMAP1 clock
 framework
References: <1398375849-6017-1-git-send-email-joelf@ti.com> <1398375849-6017-3-git-send-email-joelf@ti.com> <20140507152004.GC9502@atomide.com>
In-Reply-To: <20140507152004.GC9502@atomide.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/07/2014 10:20 AM, Tony Lindgren wrote:
> * Joel Fernandes <joelf@ti.com> [140424 14:44]:
>> OMAP1 doesn't support clock framework, add a comment where needed
>> and correct a FIXME.
> 
> This is at least a wrong comment, the original comment seems right
> to me.

Can you elaborate a bit more please on the wrongness of the comment?

I can change the comment to say "common clock" instead of "clock" if
that's the only problem here.

 thanks,

-Joel
