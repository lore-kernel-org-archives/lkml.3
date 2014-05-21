Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753903AbaEUWOi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 18:14:38 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42724 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753210AbaEUWOg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 18:14:36 -0400
Message-ID: <537D2522.80702@zytor.com>
Date: Wed, 21 May 2014 15:13:54 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: Andy Lutomirski <luto@amacapital.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jiri Kosina <jkosina@suse.cz>, Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>, Andi Kleen <andi@firstfloor.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, "Luck, Tony" <tony.luck@intel.com>
Subject: Re: [RFC] x86_64: A real proposal for iret-less return to kernel
References: <alpine.LRH.2.00.1405211450410.27739@twin.jikos.cz> <CALCETrXO9EyWs5hykkAO2wU8udW0WE9AHfvjGog7s9ydPf4iEw@mail.gmail.com> <20140521163315.GJ21205@pd.tnic> <alpine.LNX.2.00.1405212323190.12047@pobox.suse.cz> <CA+55aFwiZxg3kS7seKPnkteOBA5N8ENXt6Y+Azn_HH6Z1iRN5w@mail.gmail.com> <20140521214319.GF25130@pd.tnic> <537D1E8B.1010505@zytor.com> <CALCETrVP3WtaQ72RgaPUuF2tAZRmJUtEyzyGMKWytv422_thmw@mail.gmail.com> <20140521215411.GI25130@pd.tnic> <537D21F2.8030702@zytor.com> <20140521221121.GL25130@pd.tnic>
In-Reply-To: <20140521221121.GL25130@pd.tnic>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/21/2014 03:11 PM, Borislav Petkov wrote:
> On Wed, May 21, 2014 at 03:00:18PM -0700, H. Peter Anvin wrote:
>> So this is not a problem then.
> 
> Yeah, f'get it - it is all good at that front. :-)
> 

Seems like a comment would be in order, though.

	-hpa

