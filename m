Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752885Ab3C1PEG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 11:04:06 -0400
Received: from mail.southpole.se ([37.247.8.11]:55463 "EHLO mail.southpole.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751160Ab3C1PEE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 11:04:04 -0400
Message-ID: <51545BFB.9010806@southpole.se>
Date: Thu, 28 Mar 2013 16:04:27 +0100
From: Jonas Bonn <jonas@southpole.se>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: rkuo@codeaurora.org
CC: Paul Bolle <pebolle@tiscali.nl>, linux-hexagon@vger.kernel.org,
        linux@openrisc.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arch: remove CONFIG_GENERIC_FIND_NEXT_BIT again
References: <1363872898.1390.143.camel@x61.thuisdomein> <ed19f23c22d5a92cda8e3622060bed61.squirrel@www.codeaurora.org>
In-Reply-To: <ed19f23c22d5a92cda8e3622060bed61.squirrel@www.codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Assp-Version: 2.2.2(12343) on assp.southpole.se
X-Assp-Client-TLS: yes
X-Assp-Server-TLS: yes
X-Assp-ID: assp.southpole.se 83039-10038
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Richard,

On 03/26/2013 03:53 AM, rkuo@codeaurora.org wrote:
>> CONFIG_GENERIC_FIND_NEXT_BIT was removed in v3.0, but reappeared in two
>> architectures. Remove it again.
>>
>
> I'd be fine pulling these into my tree to go with my next batch of
> changes, or the OpenRISC folks can if they want.  Ack would be nice.

Go ahead and take this patch via your tree.

>
> Just in case:
>
> Acked-by: Richard Kuo <rkuo@codeaurora.org>

Acked-by: Jonas Bonn <jonas@southpole.se>

Thanks,
Jonas
