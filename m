Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932566Ab3KMJ1U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 04:27:20 -0500
Received: from top.free-electrons.com ([176.31.233.9]:47119 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932344Ab3KMJ1Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 04:27:16 -0500
Message-ID: <528345F1.8000200@free-electrons.com>
Date: Wed, 13 Nov 2013 10:27:13 +0100
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Arend van Spriel <arend@broadcom.com>, trivial@kernel.org
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [RESEND][TRIVIAL] treewide: fix occurrences of "the the
 "
References: <1384233016-15188-1-git-send-email-michael.opdenacker@free-electrons.com> <5281E797.9030101@broadcom.com>
In-Reply-To: <5281E797.9030101@broadcom.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arend,

Thank you for reviewing this patch!

On 11/12/2013 09:32 AM, Arend van Spriel wrote:
> On 11/12/2013 06:10 AM, Michael Opdenacker wrote:
>>
>> This is an update to the patch sent on Sep. 12, 2013
>
> Better put this kind of info below the signed-off-by line. Or even
> better use the message-id of that patch in the 'In-Reply-To:' field
> that git-send-email prompts for.
This definitely makes sense. Thank you very much for your valuable
advise! I will do it next time :)

Cheers,

Michael.


>
> For driver change mentioned below:
> Acked-by: Arend van Spriel <arend@broadcom.com>
>> Signed-off-by: Michael Opdenacker
>> <michael.opdenacker@free-electrons.com>
> ---
> so here: 'This is an update to the patch sent on Sep. 12, 2013'
>> ---
>>   drivers/net/wireless/brcm80211/brcmsmac/main.c                 | 2 +-
>
>


-- 
Michael Opdenacker, CEO, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
+33 484 258 098

