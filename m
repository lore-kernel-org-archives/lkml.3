Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751622AbaB0Iv1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 03:51:27 -0500
Received: from mail-ea0-f178.google.com ([209.85.215.178]:64180 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750813AbaB0IvZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 03:51:25 -0500
Message-ID: <530EFC89.2010409@suse.cz>
Date: Thu, 27 Feb 2014 09:51:21 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>, gregkh@linuxfoundation.org
CC: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        jwboyer@fedoraproject.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org
Subject: Re: 3.12-stable kernel tree being taken over by Jiri Slaby
References: <20140226231910.GA8789@kroah.com> <20140226.183927.1607497823277720839.davem@davemloft.net> <530EFA78.1020802@suse.cz>
In-Reply-To: <530EFA78.1020802@suse.cz>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/27/2014 09:42 AM, Jiri Slaby wrote:
> On 02/27/2014 12:39 AM, David Miller wrote:
>> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> Date: Wed, 26 Feb 2014 15:19:10 -0800
>>
>>> David, I don't know if you want to keep doing 3.12-networking patches or
>>> not, I'll let you work that out with Jiri directly.
>>
>> 3.12 and 3.13 are very similar, so the work is minimal, therefore I'm
>> likely to keep doing it.
> 
> Hi, do you have any plans including:
> commit 18fc25c94eadc52a42c025125af24657a93638c0
> Author: Venkat Venkatsubra <venkat.x.venkatsubra@oracle.com>
> Date:   Mon Dec 2 15:41:39 2013 -0800
> 
>     rds: prevent BUG_ON triggered on congestion update to loopback
> 
> which is not needed for 3.13, but is needed for 3.12 to fix CVE-2012-2372?

Nevermind, cherry-pick taught me, that it is already in 3.12.8. We just
have a different fix in the suse tree which should be dropped now.

Sorry for the noise.

-- 
js
suse labs
