Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753686AbaBYUiU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 15:38:20 -0500
Received: from terminus.zytor.com ([198.137.202.10]:59762 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752844AbaBYUiS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 15:38:18 -0500
Message-ID: <530CFF25.1080100@zytor.com>
Date: Tue, 25 Feb 2014 12:37:57 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Daniel Borkmann <dborkman@redhat.com>
CC: Jan Beulich <JBeulich@suse.com>, mingo@elte.hu, tglx@linutronix.de,
        davem@davemloft.net, ffusco@redhat.com, tgraf@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] x86/hash: swap parameters of crc32_u32()
References: <53073986020000780011E2E1@nat28.tlf.novell.com> <530CFC93.8080505@zytor.com> <530CFE3A.2090403@redhat.com>
In-Reply-To: <530CFE3A.2090403@redhat.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/25/2014 12:34 PM, Daniel Borkmann wrote:
> On 02/25/2014 09:26 PM, H. Peter Anvin wrote:
>> On 02/21/2014 02:33 AM, Jan Beulich wrote:
>>> ... to match its two callers (i.e. the alternative would have been to
>>> swap the arguments at the call sites).
>>>
>>> Signed-off-by: Jan Beulich <jbeulich@suse.com>
>>> Cc: Francesco Fusco <ffusco@redhat.com>
>>> Cc: Daniel Borkmann <dborkman@redhat.com>
>>> Cc: Thomas Graf <tgraf@redhat.com>
>>> Cc: David S. Miller <davem@davemloft.net>
>>> ---
>>>   arch/x86/lib/hash.c |    2 +-
>>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> Jan, do you want to do an updated version of this patch?  Daniel, I
>> presume you are going to push this patch?
> 
> Good point. I'm fine if this is going to be picked up
> by x86 maintainers. Feel free to add my ...
> 
> Acked-by: Daniel Borkmann <dborkman@redhat.com>
> 
> ... if you want to do an updated version that also
> includes our recent findings/discussion, Jan.
> 

Well, I don't want to change the names of the arguments in the inline
function unless we also change the their functions and actually reverse
the order of the operands as used.

	-hpa


