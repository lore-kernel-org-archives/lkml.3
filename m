Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752337AbaABWOi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 17:14:38 -0500
Received: from mail-pb0-f44.google.com ([209.85.160.44]:57811 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751574AbaABWOg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 17:14:36 -0500
Message-ID: <52C5E4C9.7030500@lwfinger.net>
Date: Thu, 02 Jan 2014 16:14:33 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Geert Uytterhoeven <geert@linux-m68k.org>, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: Question on compiler warning
References: <52C21CE3.3020402@lwfinger.net> <alpine.DEB.2.02.1401021354400.21537@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.02.1401021354400.21537@chino.kir.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/02/2014 03:56 PM, David Rientjes wrote:
> On Mon, 30 Dec 2013, Larry Finger wrote:
>
>> + /scratch/kisskb/src/drivers/net/wireless/b43/phy_n.c: warning: 'val_addr'
>> may be used uninitialized in this function [-Wuninitialized]: => 178:21
>>
>> This warning does not show up on any of my compilers, and it should not as the
>> initialization and usage of that variable both take place in conditional
>> branches that are testing exactly the same pointer.
>>
>
> You may not be compiling this file depending on your .config or you may
> have a different setting for CONFIG_CC_OPTIMIZE_FOR_SIZE.

I am definitely building this driver in my configuration. Variable 
CONFIG_CC_OPTIMIZE_FOR_SIZE was not set, but changing it to "y" did not change 
the result.

Thanks,

Larry


