Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758214Ab3EHUh7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 16:37:59 -0400
Received: from mail.candelatech.com ([208.74.158.172]:41056 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757502Ab3EHUh7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 16:37:59 -0400
Message-ID: <518AB7A6.30602@candelatech.com>
Date: Wed, 08 May 2013 13:37:58 -0700
From: Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: relayfs question related to removing parent directory.
References: <518AB646.1000406@candelatech.com> <20130508203547.GX25399@ZenIV.linux.org.uk>
In-Reply-To: <20130508203547.GX25399@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/08/2013 01:35 PM, Al Viro wrote:
> On Wed, May 08, 2013 at 01:32:06PM -0700, Ben Greear wrote:
>> I'm seeing a crash when unloading the ath9k module.
>>
>> It seems relay_close() is being passed bad memory.
>>
>> The relay_open call uses an ath9k debugfs directory, so
>> that may be removed before the call to relay_close()
>> is called.
>>
>> Does relayfs automatically close files when the parent
>> directory is removed?
>
> Why and how the hell would it possibly manage such a miracle?
>

No idea..I'm just trying to figure out why it is crashing
....don't see anything obvious in ath9k itself, but still looking.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

