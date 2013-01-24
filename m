Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752849Ab3AXRdA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 12:33:00 -0500
Received: from terminus.zytor.com ([198.137.202.10]:59524 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751740Ab3AXRc6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 12:32:58 -0500
Message-ID: <51017028.3020001@zytor.com>
Date: Thu, 24 Jan 2013 11:32:24 -0600
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: Jan Beulich <JBeulich@suse.com>, mingo@elte.hu, tglx@linutronix.de,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3, v2] x86: xor-block handling adjustments
References: <5093E40902000078000A6147@nat28.tlf.novell.com> <20130124171554.GC11772@gmail.com>
In-Reply-To: <20130124171554.GC11772@gmail.com>
X-Enigmail-Version: 1.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/24/2013 11:15 AM, Ingo Molnar wrote:
> 
> * Jan Beulich <JBeulich@suse.com> wrote:
> 
>> v2 of this series is merely updated on top of the changes between
>> 3.6 and 3.7-rc (which includes the dropping of what previously was
>> the second patch in a four patch series).
>>
>> 1: unify SSE-base xor-block routines
>> 2: add alternative SSE implementation only prefetching once per 64-byte line
>> 3: make virtualization friendly
>>
>> Signed-off-by: Jan Beulich <jbeulich@suse.com>
> 
> Looks useful. Wondering what the status is: hpa, was your 
> concern resolved, do you think we can apply these?
> 

I don't see anything wrong, except that I can't *find* patch 3/3 either
in my inbox nor on LKML...

	-hpa


