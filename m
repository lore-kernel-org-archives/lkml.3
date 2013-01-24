Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753164Ab3AXJyo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 04:54:44 -0500
Received: from multi.imgtec.com ([194.200.65.239]:43382 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752731Ab3AXJyj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 04:54:39 -0500
Message-ID: <510104DB.9040403@imgtec.com>
Date: Thu, 24 Jan 2013 09:54:35 +0000
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Vineet Gupta <Vineet.Gupta1@synopsys.com>
CC: David Howells <dhowells@redhat.com>, <linux-arch@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <arnd@arndb.de>
Subject: Re: [PATCH v2 65/76] ARC: UAPI Disintegrate arch/arc/include/asm
References: <50FFCAC4.1050002@synopsys.com> <1358511930-7424-1-git-send-email-vgupta@synopsys.com> <1358511930-7424-66-git-send-email-vgupta@synopsys.com> <10760.1358945425@warthog.procyon.org.uk> <5100CAAF.8090702@synopsys.com>
In-Reply-To: <5100CAAF.8090702@synopsys.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.154.65]
X-SEF-Processed: 7_3_0_01181__2013_01_24_09_54_36
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vineet,

On 24/01/13 05:46, Vineet Gupta wrote:
> On Wednesday 23 January 2013 06:20 PM, David Howells wrote:
>> Vineet Gupta <Vineet.Gupta1@synopsys.com> wrote:
>>
>>> I generated this patch using the scripts you provided. If these look OK to
>>> you, can you please ACK.
>>
>> You need to take a look at uapi/asm/setup.h.  It's created as an empty file -
>> which will get discarded by patch.  Do you actually need a UAPI instance of
>> that?
>>
>> David
>>
> 
> Given that setup.h is exported by include/uapi/asm-generic/Kbuild.asm (as part of
> userspace header ABI) there's no way we can avoid it's uapi sibling - even if
> empty. But to workaround patch discarding it, I will add a placeholder comment in
> generated setup.h (just like you did for arch/cris). Would that take care of it ?
> 
> BTW looking at metag port, it seems that <asm/setup.h> does #include
> <uapi/asm/setup.h>, but latter doesn't exist in the repository - is it generated
> for you James or is this same issue which David elucidated to above ?

We have generic-y += setup.h in arch/metag/include/uapi/asm/Kbuild for this

Cheers
James

