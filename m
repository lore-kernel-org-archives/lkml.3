Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754003AbaA0RRI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 12:17:08 -0500
Received: from terminus.zytor.com ([198.137.202.10]:47363 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753477AbaA0RRF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 12:17:05 -0500
Message-ID: <52E69464.4010705@zytor.com>
Date: Mon, 27 Jan 2014 09:16:20 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>, Jiri Kosina <jkosina@suse.cz>
CC: Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Michael Matz <matz@suse.de>,
        Michal Hocko <mhocko@suse.cz>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] x86: Disable traditional FPU instructions too
References: <20140127163758.GC6839@pd.tnic> <52E68C25.1070804@zytor.com>	<alpine.LNX.2.00.1401271742300.14101@pobox.suse.cz> <87ha8pqryl.fsf@tassilo.jf.intel.com>
In-Reply-To: <87ha8pqryl.fsf@tassilo.jf.intel.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/27/2014 09:01 AM, Andi Kleen wrote:
> Jiri Kosina <jkosina@suse.cz> writes:
> 
>> On Mon, 27 Jan 2014, H. Peter Anvin wrote:
>>
>>> I don't think it'd hurt... although I think the above pretty much
>>> requires that the code contain actual floating-point types to ever be
>>> generated.  
>>
>> Unfortunately using float-typed constants (such as 1EexpL) are enough for 
>> this to happen.
> 
> checkpatch would seem to be the right place to check for this?
> 

Ideally gcc should have a -no-float option...

	-hpa


