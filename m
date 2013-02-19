Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758731Ab3BSRxT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 12:53:19 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44613 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757885Ab3BSRxS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 12:53:18 -0500
Message-ID: <5123BBBC.2080008@zytor.com>
Date: Tue, 19 Feb 2013 09:51:56 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@kernel.org>,
        Boris Ostrovsky <boris.ostrovsky@amd.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] x86/cpu changes for v3.9
References: <20130219152503.GA14862@gmail.com> <20130219153655.GD26748@pd.tnic> <20130219154721.GA15876@gmail.com> <5123B897.9010607@zytor.com> <20130219174758.GB4465@pd.tnic>
In-Reply-To: <20130219174758.GB4465@pd.tnic>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/19/2013 09:47 AM, Borislav Petkov wrote:
> On Tue, Feb 19, 2013 at 09:38:31AM -0800, H. Peter Anvin wrote:
>> My fault... I was tracking the fix and lost track of the thread.
>>
>> The problem is that the fix is necessary but not sufficient, as it
>> introduces an undesirable host-guest dependency.  In order to allow
>> neerw guests to work on older hosts we also should use the
>> {rd,wr}msr_safe() functions to manipulate this MSR, with a comment
>> as to why.
>>
>> Boris, could you prepare such a patch, please?
>
> I don't think Boris O. is at AMD anymore. Want me to add that to my fix
> for kvm or prep a separate patch?
>

Separate patch, please, and yes, I would greatly appreciate it.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

