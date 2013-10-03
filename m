Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755335Ab3JCUDw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 16:03:52 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:31445 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755287Ab3JCUDu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 16:03:50 -0400
Message-ID: <524DCD9E.1080401@oracle.com>
Date: Thu, 03 Oct 2013 14:03:42 -0600
From: Khalid Aziz <khalid.aziz@oracle.com>
Organization: Oracle Corp
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Christoph Biedl <linux-kernel.bfrz@manchmal.in-ulm.de>
CC: stable@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [ 00/13] 3.0.99-stable review
References: <20131003040400.753642257@linuxfoundation.org> <524D0663.209@roeck-us.net> <1380801873@msgid.manchmal.in-ulm.de> <524D72A7.8030200@oracle.com> <1380810793@msgid.manchmal.in-ulm.de> <524D85BA.9030603@oracle.com> <524D896F.7080801@oracle.com> <1380827524@msgid.manchmal.in-ulm.de>
In-Reply-To: <1380827524@msgid.manchmal.in-ulm.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/03/2013 01:15 PM, Christoph Biedl wrote:
> Khalid Aziz wrote...
>
>> Better yet, just pull this patch from stable from now. I will redo
>> the patch and send another one for the next round.
>
> FYI, after patching mm/swap.c accordingly, all the 3.0 and 3.4
> configurations I use do build. Some boot tests will follow, I'll
> follow up only if I see unusual behaviour.
>
>      Christoph
>

Thanks for testing, Christoph. I will create a v2 of this patch with 
this change for the next round of stable kernels.

--
Khalid

